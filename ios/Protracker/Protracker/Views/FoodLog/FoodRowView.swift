import SwiftUI

struct FoodRowView: View {
    let food: FoodItem
    var onToggleFavorite: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(food.name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    if let brand = food.brand {
                        Text(brand)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text("\(food.servingSize.oneDecimal)\(food.servingUnit)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(food.proteinPerServing.wholeNumber)g")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.proteinColor)

                Text("\(food.caloriesPerServing.wholeNumber) kcal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let onToggleFavorite {
                Button(action: onToggleFavorite) {
                    Image(systemName: food.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(food.isFavorite ? .yellow : .secondary)
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FoodLogEntryRow: View {
    let entry: FoodLogEntry

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.foodItem?.name ?? "Unknown Food")
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)

                Text("\(entry.numberOfServings.oneDecimal) serving\(entry.numberOfServings == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(entry.totalProtein.wholeNumber)g")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.proteinColor)

                Text("\(entry.totalCalories.wholeNumber) kcal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
