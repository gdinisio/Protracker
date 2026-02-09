import SwiftUI

struct FavoriteFoodsSection: View {
    let foods: [FoodItem]
    var onToggleFavorite: ((FoodItem) -> Void)?

    var body: some View {
        if !foods.isEmpty {
            Section {
                ForEach(foods) { food in
                    NavigationLink(value: food) {
                        FoodRowView(food: food) {
                            onToggleFavorite?(food)
                        }
                    }
                }
            } header: {
                Label("Favorites", systemImage: "star.fill")
                    .font(.subheadline.weight(.semibold))
            }
        }
    }
}
