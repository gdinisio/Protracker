import SwiftUI
import SwiftData

struct FoodDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let foodItem: FoodItem

    @State private var servings: Double = 1.0
    @State private var selectedMeal: MealType = .lunch
    @State private var didLog = false

    private var nutrients: NutrientInfo {
        NutrientCalculator.nutrients(for: foodItem, servings: servings)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                servingSection
                nutrientSection
                mealPickerSection
                logButton
            }
            .padding()
        }
        .background { GradientBackground() }
        .navigationTitle("Food Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }

    // MARK: - Header

    private var headerCard: some View {
        GlassCard(cornerRadius: 24) {
            VStack(spacing: 10) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 40))
                    .foregroundStyle(.accent)
                    .symbolEffect(.bounce, value: didLog)

                Text(foodItem.name)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)

                if let brand = foodItem.brand {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 16) {
                    Label(foodItem.category, systemImage: "tag.fill")
                    Label("\(foodItem.servingSize.oneDecimal)\(foodItem.servingUnit)", systemImage: "scalemass.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var categoryIcon: String {
        switch foodItem.category {
        case "Poultry", "Meat": return "fork.knife"
        case "Fish & Seafood": return "fish.fill"
        case "Dairy": return "cup.and.saucer.fill"
        case "Eggs": return "oval.fill"
        case "Legumes": return "leaf.fill"
        case "Nuts & Seeds": return "tree.fill"
        case "Grains": return "wheat.bundle.fill"
        case "Vegetables": return "carrot.fill"
        case "Fruits": return "apple.logo"
        case "Supplements": return "pill.fill"
        case "Prepared Foods": return "takeoutbag.and.cup.and.straw.fill"
        case "Snacks": return "popcorn.fill"
        case "Beverages": return "wineglass.fill"
        default: return "circle.grid.2x2.fill"
        }
    }

    // MARK: - Servings

    private var servingSection: some View {
        GlassCard(cornerRadius: 16) {
            NumberStepperView(
                value: $servings,
                range: 0.5...20,
                step: 0.5,
                label: "Servings"
            )
        }
    }

    // MARK: - Nutrients

    private var nutrientSection: some View {
        GlassCard(cornerRadius: 16) {
            VStack(spacing: 14) {
                HStack {
                    Text("Nutrition")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("\(nutrients.calories.wholeNumber) kcal")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.orange)
                        .contentTransition(.numericText())
                }

                NutrientBarView(
                    label: "Protein",
                    current: nutrients.protein,
                    goal: 150,
                    color: .proteinColor,
                    unit: "g"
                )

                NutrientBarView(
                    label: "Carbs",
                    current: nutrients.carbs,
                    goal: 250,
                    color: .carbColor,
                    unit: "g"
                )

                NutrientBarView(
                    label: "Fat",
                    current: nutrients.fat,
                    goal: 65,
                    color: .fatColor,
                    unit: "g"
                )
            }
        }
    }

    // MARK: - Meal Picker

    private var mealPickerSection: some View {
        GlassCard(cornerRadius: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Add to Meal")
                    .font(.subheadline.weight(.semibold))

                HStack(spacing: 8) {
                    ForEach(MealType.allCases) { meal in
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedMeal = meal
                            }
                            HapticManager.selection()
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: meal.iconName)
                                    .font(.body)
                                Text(meal.rawValue)
                                    .font(.caption2.weight(.medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.glass)
                        .opacity(selectedMeal == meal ? 1.0 : 0.5)
                    }
                }
            }
        }
    }

    // MARK: - Log Button

    private var logButton: some View {
        Button {
            let vm = FoodLogViewModel(modelContext: modelContext)
            vm.logFood(foodItem, servings: servings, mealType: selectedMeal)
            didLog = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Log \(nutrients.protein.wholeNumber)g Protein")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.glassProminent)
        .disabled(didLog)
    }
}

#Preview {
    NavigationStack {
        FoodDetailView(
            foodItem: {
                let f = FoodItem(
                    name: "Chicken Breast",
                    servingSize: 100,
                    servingUnit: "g",
                    proteinPerServing: 31,
                    carbsPerServing: 0,
                    fatPerServing: 3.6,
                    caloriesPerServing: 165,
                    category: "Poultry"
                )
                return f
            }()
        )
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
