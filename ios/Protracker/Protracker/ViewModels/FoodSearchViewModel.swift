import SwiftData
import SwiftUI

@Observable
final class FoodSearchViewModel {
    var searchText: String = ""
    var selectedCategory: String?
    var results: [FoodItem] = []
    var favorites: [FoodItem] = []
    var recentFoods: [FoodItem] = []
    var categories: [String] = []

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadCategories()
        loadFavorites()
        loadRecent()
        search()
    }

    func search() {
        results = FoodDatabaseService.searchFoods(
            query: searchText,
            category: selectedCategory,
            context: modelContext
        )
    }

    func loadFavorites() {
        favorites = FoodDatabaseService.favorites(context: modelContext)
    }

    func loadRecent() {
        recentFoods = FoodDatabaseService.recentFoods(context: modelContext)
    }

    func loadCategories() {
        categories = FoodDatabaseService.categories(context: modelContext)
    }

    func toggleFavorite(_ food: FoodItem) {
        food.isFavorite.toggle()
        HapticManager.impact(.light)
        loadFavorites()
    }
}
