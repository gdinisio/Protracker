import SwiftData
import SwiftUI

@Observable
final class AchievementsViewModel {
    var achievements: [Achievement] = []
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var calendarData: [(date: Date, intensity: Double)] = []

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var unlockedCount: Int {
        achievements.filter(\.isUnlocked).count
    }

    var totalCount: Int {
        achievements.count
    }

    func loadData() {
        loadAchievements()
        calculateStreaks()
        buildCalendarData()
        checkAndUnlockAchievements()
    }

    private func loadAchievements() {
        let descriptor = FetchDescriptor<Achievement>(
            sortBy: [SortDescriptor(\.category), SortDescriptor(\.threshold)]
        )
        achievements = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func calculateStreaks() {
        currentStreak = StreakCalculator.currentStreak(context: modelContext)
        longestStreak = StreakCalculator.longestStreak(context: modelContext)
    }

    private func buildCalendarData() {
        let ninetyDaysAgo = Calendar.current.startOfDay(for: Date.now.daysAgo(89))
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date >= ninetyDaysAgo },
            sortBy: [SortDescriptor(\.date)]
        )
        let logs = (try? modelContext.fetch(descriptor)) ?? []

        let profileDescriptor = FetchDescriptor<UserProfile>()
        let goal = (try? modelContext.fetch(profileDescriptor).first)?.dailyProteinGoal ?? 150

        calendarData = (0...89).map { daysAgo in
            let date = Date.now.daysAgo(89 - daysAgo).startOfDay
            let log = logs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
            let intensity: Double
            if let log, goal > 0 {
                intensity = min(log.totalProtein / goal, 1.0)
            } else {
                intensity = 0
            }
            return (date: date, intensity: intensity)
        }
    }

    private func checkAndUnlockAchievements() {
        let streakAchievements = achievements.filter { $0.category == "streak" && !$0.isUnlocked }
        for a in streakAchievements {
            if currentStreak >= a.threshold || longestStreak >= a.threshold {
                a.unlock()
            }
        }

        let loggingAchievements = achievements.filter { $0.category == "logging" && !$0.isUnlocked }
        if !loggingAchievements.isEmpty {
            let totalEntries = (try? modelContext.fetchCount(FetchDescriptor<FoodLogEntry>())) ?? 0
            for a in loggingAchievements {
                if totalEntries >= a.threshold {
                    a.unlock()
                }
            }
        }

        let customFoodAchievement = achievements.first(where: { $0.key == "custom_food" && !$0.isUnlocked })
        if let customFoodAchievement {
            let descriptor = FetchDescriptor<FoodItem>(
                predicate: #Predicate<FoodItem> { $0.isCustom == true }
            )
            let count = (try? modelContext.fetchCount(descriptor)) ?? 0
            if count >= customFoodAchievement.threshold {
                customFoodAchievement.unlock()
            }
        }

        try? modelContext.save()
    }
}
