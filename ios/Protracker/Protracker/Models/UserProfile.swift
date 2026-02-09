import SwiftData
import Foundation

@Model
final class UserProfile {
    var dailyProteinGoal: Double
    var dailyCarbsGoal: Double
    var dailyFatGoal: Double
    var dailyCalorieGoal: Double
    var dailyWaterGoalML: Double
    var bodyWeightKg: Double?
    var heightCm: Double?
    var dietaryPreference: String
    var unitSystem: String
    var createdAt: Date
    var updatedAt: Date

    init(
        dailyProteinGoal: Double = 150,
        dailyCarbsGoal: Double = 250,
        dailyFatGoal: Double = 65,
        dailyCalorieGoal: Double = 2000,
        dailyWaterGoalML: Double = 2500
    ) {
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyCarbsGoal = dailyCarbsGoal
        self.dailyFatGoal = dailyFatGoal
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyWaterGoalML = dailyWaterGoalML
        self.dietaryPreference = "None"
        self.unitSystem = "metric"
        self.createdAt = .now
        self.updatedAt = .now
    }
}
