import SwiftUI
import SwiftData

struct CustomFoodFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var brand = ""
    @State private var category = "Other"
    @State private var servingSize: Double = 100
    @State private var servingUnit = "g"
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0
    @State private var calories: Double = 0
    @State private var barcode = ""

    private let categories = [
        "Meat", "Poultry", "Fish & Seafood", "Dairy", "Eggs",
        "Legumes", "Nuts & Seeds", "Grains", "Vegetables", "Fruits",
        "Supplements", "Prepared Foods", "Snacks", "Beverages", "Other"
    ]

    private let servingUnits = ["g", "ml", "oz", "cup", "tbsp", "tsp", "piece"]

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && servingSize > 0
    }

    var body: some View {
        Form {
            Section("Food Info") {
                TextField("Food Name", text: $name)
                TextField("Brand (optional)", text: $brand)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
            }

            Section("Serving Size") {
                HStack {
                    TextField("Size", value: $servingSize, format: .number)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: 100)

                    Picker("Unit", selection: $servingUnit) {
                        ForEach(servingUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }

            Section("Nutrition (per serving)") {
                NutritionField(label: "Protein", value: $protein, unit: "g", color: .proteinColor)
                NutritionField(label: "Carbs", value: $carbs, unit: "g", color: .carbColor)
                NutritionField(label: "Fat", value: $fat, unit: "g", color: .fatColor)
                NutritionField(label: "Calories", value: $calories, unit: "kcal", color: .orange)
            }

            Section("Barcode (optional)") {
                TextField("Barcode number", text: $barcode)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("Custom Food")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveFood()
                }
                .disabled(!isValid)
            }
        }
    }

    private func saveFood() {
        let food = FoodItem(
            name: name.trimmingCharacters(in: .whitespaces),
            brand: brand.isEmpty ? nil : brand,
            barcode: barcode.isEmpty ? nil : barcode,
            servingSize: servingSize,
            servingUnit: servingUnit,
            proteinPerServing: protein,
            carbsPerServing: carbs,
            fatPerServing: fat,
            caloriesPerServing: calories,
            category: category,
            isCustom: true
        )
        modelContext.insert(food)
        HapticManager.notification(.success)
        dismiss()
    }
}

private struct NutritionField: View {
    let label: String
    @Binding var value: Double
    let unit: String
    let color: Color

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
            Spacer()
            TextField("0", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 80)
            Text(unit)
                .foregroundStyle(.secondary)
                .frame(width: 36, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        CustomFoodFormView()
    }
    .modelContainer(for: [FoodItem.self], inMemory: true)
}
