import SwiftUI
import SwiftData

struct AddToMealSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let mealType: MealType

    @State private var searchText = ""
    @State private var results: [FoodItem] = []
    @State private var selectedFood: FoodItem?

    var body: some View {
        NavigationStack {
            List(results) { food in
                Button {
                    selectedFood = food
                } label: {
                    FoodRowView(food: food)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background { GradientBackground() }
            .navigationTitle("Add to \(mealType.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search foods...")
            .onChange(of: searchText) { _, newValue in
                results = FoodDatabaseService.searchFoods(
                    query: newValue,
                    context: modelContext
                )
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(item: $selectedFood) { food in
                NavigationStack {
                    FoodDetailView(foodItem: food)
                }
            }
            .onAppear {
                results = FoodDatabaseService.allFoods(context: modelContext)
            }
        }
    }
}

#Preview {
    AddToMealSheet(mealType: .lunch)
        .modelContainer(for: [
            FoodItem.self, FoodLogEntry.self, DailyLog.self,
            WaterLogEntry.self, UserProfile.self, Achievement.self
        ], inMemory: true)
}
