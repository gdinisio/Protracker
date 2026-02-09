import SwiftData
import SwiftUI

@Observable
final class FoodLogViewModel {
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func logFood(_ foodItem: FoodItem, servings: Double, mealType: MealType) {
        let entry = FoodLogEntry(
            foodItem: foodItem,
            numberOfServings: servings,
            mealType: mealType
        )

        let todayLog = getOrCreateTodayLog()
        entry.dailyLog = todayLog
        modelContext.insert(entry)

        todayLog.totalProtein += entry.totalProtein
        todayLog.totalCarbs += entry.totalCarbs
        todayLog.totalFat += entry.totalFat
        todayLog.totalCalories += entry.totalCalories

        if let profile = getProfile(),
           todayLog.totalProtein >= profile.dailyProteinGoal {
            todayLog.goalMet = true
        }

        foodItem.useCount += 1
        foodItem.lastUsed = .now

        try? modelContext.save()
        HapticManager.notification(.success)
    }

    func deleteEntry(_ entry: FoodLogEntry) {
        if let dailyLog = entry.dailyLog {
            dailyLog.totalProtein -= entry.totalProtein
            dailyLog.totalCarbs -= entry.totalCarbs
            dailyLog.totalFat -= entry.totalFat
            dailyLog.totalCalories -= entry.totalCalories

            if let profile = getProfile() {
                dailyLog.goalMet = dailyLog.totalProtein >= profile.dailyProteinGoal
            }
        }

        modelContext.delete(entry)
        try? modelContext.save()
        HapticManager.impact(.medium)
    }

    private func getOrCreateTodayLog() -> DailyLog {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date == startOfDay }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }

        let log = DailyLog(date: .now)
        modelContext.insert(log)
        return log
    }

    private func getProfile() -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>()
        return try? modelContext.fetch(descriptor).first
    }
}
