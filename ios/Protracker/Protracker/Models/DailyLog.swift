import SwiftData
import Foundation

@Model
final class DailyLog {
    var date: Date

    @Relationship(deleteRule: .cascade)
    var entries: [FoodLogEntry]?

    @Relationship(deleteRule: .cascade)
    var waterEntries: [WaterLogEntry]?

    var totalProtein: Double
    var totalCarbs: Double
    var totalFat: Double
    var totalCalories: Double
    var totalWaterML: Double

    var goalMet: Bool

    var nutrientInfo: NutrientInfo {
        NutrientInfo(
            protein: totalProtein,
            carbs: totalCarbs,
            fat: totalFat,
            calories: totalCalories
        )
    }

    var allEntries: [FoodLogEntry] {
        entries ?? []
    }

    var allWaterEntries: [WaterLogEntry] {
        waterEntries ?? []
    }

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        self.totalProtein = 0
        self.totalCarbs = 0
        self.totalFat = 0
        self.totalCalories = 0
        self.totalWaterML = 0
        self.goalMet = false
    }

    func recalculateTotals() {
        totalProtein = allEntries.reduce(0) { $0 + $1.totalProtein }
        totalCarbs = allEntries.reduce(0) { $0 + $1.totalCarbs }
        totalFat = allEntries.reduce(0) { $0 + $1.totalFat }
        totalCalories = allEntries.reduce(0) { $0 + $1.totalCalories }
        totalWaterML = allWaterEntries.reduce(0) { $0 + $1.amountML }
    }

    func entries(for mealType: MealType) -> [FoodLogEntry] {
        allEntries.filter { $0.mealType == mealType.rawValue }
            .sorted { $0.loggedAt < $1.loggedAt }
    }

    func totalProtein(for mealType: MealType) -> Double {
        entries(for: mealType).reduce(0) { $0 + $1.totalProtein }
    }
}
