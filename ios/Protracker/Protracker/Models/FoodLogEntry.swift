import SwiftData
import Foundation

@Model
final class FoodLogEntry {
    var foodItem: FoodItem?
    var numberOfServings: Double
    var mealType: String
    var loggedAt: Date
    var dailyLog: DailyLog?

    var totalProtein: Double
    var totalCarbs: Double
    var totalFat: Double
    var totalCalories: Double

    var meal: MealType {
        get { MealType(rawValue: mealType) ?? .snacks }
        set { mealType = newValue.rawValue }
    }

    init(
        foodItem: FoodItem,
        numberOfServings: Double,
        mealType: MealType,
        loggedAt: Date = .now
    ) {
        self.foodItem = foodItem
        self.numberOfServings = numberOfServings
        self.mealType = mealType.rawValue
        self.loggedAt = loggedAt
        self.totalProtein = foodItem.proteinPerServing * numberOfServings
        self.totalCarbs = foodItem.carbsPerServing * numberOfServings
        self.totalFat = foodItem.fatPerServing * numberOfServings
        self.totalCalories = foodItem.caloriesPerServing * numberOfServings
    }
}
