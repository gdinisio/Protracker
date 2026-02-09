import SwiftUI

struct RecentFoodsSection: View {
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
                Label("Recent", systemImage: "clock.fill")
                    .font(.subheadline.weight(.semibold))
            }
        }
    }
}
