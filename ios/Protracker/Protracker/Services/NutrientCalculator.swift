import Foundation

enum NutrientCalculator {
    static func nutrients(for food: FoodItem, servings: Double) -> NutrientInfo {
        NutrientInfo(
            protein: food.proteinPerServing * servings,
            carbs: food.carbsPerServing * servings,
            fat: food.fatPerServing * servings,
            calories: food.caloriesPerServing * servings
        )
    }

    static func macroPercentages(protein: Double, carbs: Double, fat: Double) -> (protein: Double, carbs: Double, fat: Double) {
        let totalCalories = (protein * 4) + (carbs * 4) + (fat * 9)
        guard totalCalories > 0 else { return (0, 0, 0) }
        return (
            protein: (protein * 4) / totalCalories * 100,
            carbs: (carbs * 4) / totalCalories * 100,
            fat: (fat * 9) / totalCalories * 100
        )
    }

    static func averageProtein(logs: [DailyLog]) -> Double {
        guard !logs.isEmpty else { return 0 }
        let total = logs.reduce(0.0) { $0 + $1.totalProtein }
        return total / Double(logs.count)
    }

    static func bestDay(logs: [DailyLog]) -> DailyLog? {
        logs.max(by: { $0.totalProtein < $1.totalProtein })
    }

    static func goalHitRate(logs: [DailyLog]) -> Double {
        guard !logs.isEmpty else { return 0 }
        let hitCount = logs.filter(\.goalMet).count
        return Double(hitCount) / Double(logs.count) * 100
    }
}
