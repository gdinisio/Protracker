import SwiftUI

struct FoodSearchView: View {
    @Bindable var viewModel: FoodSearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            categoryFilterBar

            if viewModel.results.isEmpty {
                EmptyStateView(
                    iconName: "magnifyingglass",
                    title: "No Results",
                    message: "Try a different search term or category filter."
                )
                .frame(maxHeight: .infinity)
            } else {
                List(viewModel.results) { food in
                    NavigationLink(value: food) {
                        FoodRowView(food: food) {
                            viewModel.toggleFavorite(food)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }

    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    label: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                    viewModel.search()
                }

                ForEach(viewModel.categories, id: \.self) { category in
                    FilterChip(
                        label: category,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                        viewModel.search()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            HapticManager.selection()
        }) {
            Text(label)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
        }
        .buttonStyle(.glass)
        .opacity(isSelected ? 1.0 : 0.6)
    }
}
