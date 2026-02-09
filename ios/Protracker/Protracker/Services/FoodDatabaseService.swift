import SwiftData
import Foundation

enum FoodDatabaseService {
    static func searchFoods(
        query: String,
        category: String? = nil,
        context: ModelContext
    ) -> [FoodItem] {
        if query.isEmpty && category == nil {
            return allFoods(context: context)
        }

        var descriptor: FetchDescriptor<FoodItem>

        if let category, !query.isEmpty {
            let searchText = query.lowercased()
            descriptor = FetchDescriptor<FoodItem>(
                predicate: #Predicate<FoodItem> { food in
                    food.category == category &&
                    (food.name.localizedStandardContains(searchText) ||
                     (food.brand ?? "").localizedStandardContains(searchText))
                },
                sortBy: [SortDescriptor(\.useCount, order: .reverse)]
            )
        } else if let category {
            descriptor = FetchDescriptor<FoodItem>(
                predicate: #Predicate<FoodItem> { food in
                    food.category == category
                },
                sortBy: [SortDescriptor(\.useCount, order: .reverse)]
            )
        } else {
            let searchText = query.lowercased()
            descriptor = FetchDescriptor<FoodItem>(
                predicate: #Predicate<FoodItem> { food in
                    food.name.localizedStandardContains(searchText) ||
                    (food.brand ?? "").localizedStandardContains(searchText)
                },
                sortBy: [SortDescriptor(\.useCount, order: .reverse)]
            )
        }

        return (try? context.fetch(descriptor)) ?? []
    }

    static func allFoods(context: ModelContext) -> [FoodItem] {
        let descriptor = FetchDescriptor<FoodItem>(
            sortBy: [SortDescriptor(\.name)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    static func favorites(context: ModelContext) -> [FoodItem] {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.useCount, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    static func recentFoods(context: ModelContext, limit: Int = 20) -> [FoodItem] {
        var descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.lastUsed != nil },
            sortBy: [SortDescriptor(\.lastUsed, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }

    static func categories(context: ModelContext) -> [String] {
        let foods = allFoods(context: context)
        let categories = Set(foods.map(\.category))
        return categories.sorted()
    }

    static func findByBarcode(_ barcode: String, context: ModelContext) -> FoodItem? {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.barcode == barcode }
        )
        return try? context.fetch(descriptor).first
    }
}
