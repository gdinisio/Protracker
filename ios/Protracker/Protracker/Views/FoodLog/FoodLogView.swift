import SwiftUI
import SwiftData

struct FoodLogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: FoodSearchViewModel?
    @State private var showCustomFood = false
    @State private var showBarcodeScanner = false

    var body: some View {
        Group {
            if let viewModel {
                mainContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background { GradientBackground() }
        .navigationTitle("Log Food")
        .searchable(
            text: Binding(
                get: { viewModel?.searchText ?? "" },
                set: { newValue in
                    viewModel?.searchText = newValue
                    viewModel?.search()
                }
            ),
            prompt: "Search foods..."
        )
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showBarcodeScanner = true
                } label: {
                    Image(systemName: "barcode.viewfinder")
                }

                Button {
                    showCustomFood = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: FoodItem.self) { food in
            FoodDetailView(foodItem: food)
        }
        .sheet(isPresented: $showCustomFood) {
            NavigationStack {
                CustomFoodFormView()
            }
        }
        #if canImport(VisionKit)
        .fullScreenCover(isPresented: $showBarcodeScanner) {
            BarcodeScannerView()
        }
        #endif
        .onAppear {
            if viewModel == nil {
                viewModel = FoodSearchViewModel(modelContext: modelContext)
            }
        }
    }

    @ViewBuilder
    private func mainContent(viewModel: FoodSearchViewModel) -> some View {
        if viewModel.searchText.isEmpty && viewModel.selectedCategory == nil {
            browseView(viewModel: viewModel)
        } else {
            FoodSearchView(viewModel: viewModel)
        }
    }

    private func browseView(viewModel: FoodSearchViewModel) -> some View {
        List {
            FavoriteFoodsSection(foods: viewModel.favorites) { food in
                viewModel.toggleFavorite(food)
            }

            RecentFoodsSection(foods: viewModel.recentFoods) { food in
                viewModel.toggleFavorite(food)
            }

            Section {
                ForEach(viewModel.results) { food in
                    NavigationLink(value: food) {
                        FoodRowView(food: food) {
                            viewModel.toggleFavorite(food)
                        }
                    }
                }
            } header: {
                Label("All Foods", systemImage: "list.bullet")
                    .font(.subheadline.weight(.semibold))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        FoodLogView()
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
