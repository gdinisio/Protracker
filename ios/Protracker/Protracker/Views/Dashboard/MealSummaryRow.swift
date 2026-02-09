import SwiftUI

struct MealSummaryRow: View {
    let mealType: MealType
    let proteinAmount: Double
    let entryCount: Int
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: mealType.iconName)
                    .font(.title3)
                    .foregroundStyle(mealType.color)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mealType.rawValue)
                        .font(.subheadline.weight(.semibold))

                    Text(entryCount == 0 ? "No items logged" : "\(entryCount) item\(entryCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(proteinAmount.wholeNumber + "g")
                    .font(.body.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.proteinColor)
                    .contentTransition(.numericText())

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        VStack(spacing: 8) {
            MealSummaryRow(mealType: .breakfast, proteinAmount: 32, entryCount: 2)
            MealSummaryRow(mealType: .lunch, proteinAmount: 45, entryCount: 3)
            MealSummaryRow(mealType: .dinner, proteinAmount: 0, entryCount: 0)
            MealSummaryRow(mealType: .snacks, proteinAmount: 10, entryCount: 1)
        }
        .padding()
    }
}
