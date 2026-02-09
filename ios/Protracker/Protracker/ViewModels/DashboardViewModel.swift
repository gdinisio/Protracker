import SwiftData
import SwiftUI

@Observable
final class DashboardViewModel {
    var todayLog: DailyLog?
    var userProfile: UserProfile?
    var currentStreak: Int = 0
    var recentFavorites: [FoodItem] = []

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var proteinConsumed: Double {
        todayLog?.totalProtein ?? 0
    }

    var proteinGoal: Double {
        userProfile?.dailyProteinGoal ?? 150
    }

    var proteinProgress: Double {
        guard proteinGoal > 0 else { return 0 }
        return proteinConsumed / proteinGoal
    }

    var proteinRemaining: Double {
        max(0, proteinGoal - proteinConsumed)
    }

    var carbsConsumed: Double {
        todayLog?.totalCarbs ?? 0
    }

    var fatConsumed: Double {
        todayLog?.totalFat ?? 0
    }

    var caloriesConsumed: Double {
        todayLog?.totalCalories ?? 0
    }

    var waterConsumed: Double {
        todayLog?.totalWaterML ?? 0
    }

    var waterGoal: Double {
        userProfile?.dailyWaterGoalML ?? 2500
    }

    var waterProgress: Double {
        guard waterGoal > 0 else { return 0 }
        return waterConsumed / waterGoal
    }

    var waterGlasses: Int {
        Int(waterConsumed / 250)
    }

    func loadData() {
        loadProfile()
        loadTodayLog()
        calculateStreak()
        loadFavorites()
    }

    private func loadProfile() {
        let descriptor = FetchDescriptor<UserProfile>()
        userProfile = try? modelContext.fetch(descriptor).first

        if userProfile == nil {
            let profile = UserProfile()
            modelContext.insert(profile)
            userProfile = profile
        }
    }

    private func loadTodayLog() {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date == startOfDay }
        )
        todayLog = try? modelContext.fetch(descriptor).first

        if todayLog == nil {
            let log = DailyLog(date: .now)
            modelContext.insert(log)
            todayLog = log
        }
    }

    private func calculateStreak() {
        currentStreak = StreakCalculator.currentStreak(context: modelContext)
    }

    private func loadFavorites() {
        var descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.useCount, order: .reverse)]
        )
        descriptor.fetchLimit = 10
        recentFavorites = (try? modelContext.fetch(descriptor)) ?? []
    }

    func addWater(ml: Double) {
        guard let todayLog else { return }
        let entry = WaterLogEntry(amountML: ml)
        entry.dailyLog = todayLog
        modelContext.insert(entry)
        todayLog.totalWaterML += ml

        if let profile = userProfile, todayLog.totalWaterML >= profile.dailyWaterGoalML {
            HapticManager.notification(.success)
        } else {
            HapticManager.impact(.light)
        }
    }
}
