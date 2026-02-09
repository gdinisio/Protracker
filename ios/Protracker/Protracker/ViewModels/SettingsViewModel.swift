import SwiftData
import SwiftUI

@Observable
final class SettingsViewModel {
    var userProfile: UserProfile?
    var totalFoodsLogged: Int = 0
    var totalDaysTracked: Int = 0
    var customFoodsCount: Int = 0

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadData() {
        loadProfile()
        loadStats()
    }

    func saveProfile() {
        userProfile?.updatedAt = .now
        try? modelContext.save()
        HapticManager.notification(.success)
    }

    func clearAllData() {
        try? modelContext.delete(model: FoodLogEntry.self)
        try? modelContext.delete(model: DailyLog.self)
        try? modelContext.delete(model: WaterLogEntry.self)

        let achievements = (try? modelContext.fetch(FetchDescriptor<Achievement>())) ?? []
        for a in achievements {
            a.isUnlocked = false
            a.unlockedAt = nil
        }

        try? modelContext.save()
        loadStats()
        HapticManager.notification(.warning)
    }

    func exportCSV() -> String {
        let logs = (try? modelContext.fetch(FetchDescriptor<DailyLog>(sortBy: [SortDescriptor(\.date)]))) ?? []

        var csv = "Date,Protein (g),Carbs (g),Fat (g),Calories,Water (ml),Goal Met\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for log in logs {
            let date = formatter.string(from: log.date)
            csv += "\(date),\(log.totalProtein.oneDecimal),\(log.totalCarbs.oneDecimal),\(log.totalFat.oneDecimal),\(log.totalCalories.oneDecimal),\(log.totalWaterML.oneDecimal),\(log.goalMet)\n"
        }

        return csv
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

    private func loadStats() {
        totalFoodsLogged = (try? modelContext.fetchCount(FetchDescriptor<FoodLogEntry>())) ?? 0
        totalDaysTracked = (try? modelContext.fetchCount(FetchDescriptor<DailyLog>())) ?? 0
        let customDescriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.isCustom == true }
        )
        customFoodsCount = (try? modelContext.fetchCount(customDescriptor)) ?? 0
    }
}
