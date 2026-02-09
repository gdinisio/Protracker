import SwiftData
import Foundation

@Model
final class FoodItem {
    var name: String
    var brand: String?
    var barcode: String?

    var servingSize: Double
    var servingUnit: String
    var servingDescription: String?

    var proteinPerServing: Double
    var carbsPerServing: Double
    var fatPerServing: Double
    var caloriesPerServing: Double

    var isCustom: Bool
    var isFavorite: Bool
    var category: String
    var createdAt: Date
    var lastUsed: Date?
    var useCount: Int

    @Relationship(deleteRule: .cascade)
    var logEntries: [FoodLogEntry]?

    var nutrientInfo: NutrientInfo {
        NutrientInfo(
            protein: proteinPerServing,
            carbs: carbsPerServing,
            fat: fatPerServing,
            calories: caloriesPerServing
        )
    }

    init(
        name: String,
        brand: String? = nil,
        barcode: String? = nil,
        servingSize: Double = 100,
        servingUnit: String = "g",
        servingDescription: String? = nil,
        proteinPerServing: Double,
        carbsPerServing: Double = 0,
        fatPerServing: Double = 0,
        caloriesPerServing: Double = 0,
        category: String = "Other",
        isCustom: Bool = false
    ) {
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.servingDescription = servingDescription
        self.proteinPerServing = proteinPerServing
        self.carbsPerServing = carbsPerServing
        self.fatPerServing = fatPerServing
        self.caloriesPerServing = caloriesPerServing
        self.category = category
        self.isCustom = isCustom
        self.isFavorite = false
        self.createdAt = .now
        self.useCount = 0
    }
}
