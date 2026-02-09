import Foundation

struct NutrientInfo: Equatable, Sendable {
    var protein: Double
    var carbs: Double
    var fat: Double
    var calories: Double

    static let zero = NutrientInfo(protein: 0, carbs: 0, fat: 0, calories: 0)

    static func + (lhs: NutrientInfo, rhs: NutrientInfo) -> NutrientInfo {
        NutrientInfo(
            protein: lhs.protein + rhs.protein,
            carbs: lhs.carbs + rhs.carbs,
            fat: lhs.fat + rhs.fat,
            calories: lhs.calories + rhs.calories
        )
    }

    static func += (lhs: inout NutrientInfo, rhs: NutrientInfo) {
        lhs = lhs + rhs
    }
}
