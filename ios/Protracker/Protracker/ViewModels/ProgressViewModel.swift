import SwiftData
import SwiftUI

@Observable
final class ProgressViewModel {
    var weeklyLogs: [DailyLog] = []
    var monthlyLogs: [DailyLog] = []
    var todayLog: DailyLog?
    var userProfile: UserProfile?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var proteinGoal: Double {
        userProfile?.dailyProteinGoal ?? 150
    }

    var averageProtein: Double {
        NutrientCalculator.averageProtein(logs: weeklyLogs)
    }

    var bestDayProtein: Double {
        NutrientCalculator.bestDay(logs: monthlyLogs)?.totalProtein ?? 0
    }

    var goalHitRate: Double {
        NutrientCalculator.goalHitRate(logs: monthlyLogs)
    }

    var currentStreak: Int {
        StreakCalculator.currentStreak(context: modelContext)
    }

    func loadData() {
        loadProfile()
        loadTodayLog()
        loadWeeklyLogs()
        loadMonthlyLogs()
    }

    private func loadProfile() {
        let descriptor = FetchDescriptor<UserProfile>()
        userProfile = try? modelContext.fetch(descriptor).first
    }

    private func loadTodayLog() {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date == startOfDay }
        )
        todayLog = try? modelContext.fetch(descriptor).first
    }

    private func loadWeeklyLogs() {
        let sevenDaysAgo = Calendar.current.startOfDay(for: Date.now.daysAgo(6))
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date >= sevenDaysAgo },
            sortBy: [SortDescriptor(\.date)]
        )
        weeklyLogs = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func loadMonthlyLogs() {
        let thirtyDaysAgo = Calendar.current.startOfDay(for: Date.now.daysAgo(29))
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date >= thirtyDaysAgo },
            sortBy: [SortDescriptor(\.date)]
        )
        monthlyLogs = (try? modelContext.fetch(descriptor)) ?? []
    }
}
