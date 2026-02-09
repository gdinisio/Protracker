import SwiftUI

struct MacroSummaryCard: View {
    let title: String
    let value: Double
    let goal: Double
    let unit: String
    let color: Color
    let iconName: String

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(value / goal, 1.0)
    }

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(color)

            Text(value.wholeNumber)
                .font(.title2.weight(.bold).monospacedDigit())
                .contentTransition(.numericText())

            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 4)

                    Capsule()
                        .fill(color.gradient)
                        .frame(width: geo.size.width * progress, height: 4)
                }
            }
            .frame(height: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

struct MacroSummaryRow: View {
    let protein: Double
    let carbs: Double
    let fat: Double
    let calories: Double
    let proteinGoal: Double
    let carbsGoal: Double
    let fatGoal: Double

    var body: some View {
        GlassEffectContainer {
            HStack(spacing: 10) {
                MacroSummaryCard(
                    title: "Protein",
                    value: protein,
                    goal: proteinGoal,
                    unit: "g",
                    color: .proteinColor,
                    iconName: "flame.fill"
                )

                MacroSummaryCard(
                    title: "Carbs",
                    value: carbs,
                    goal: carbsGoal,
                    unit: "g",
                    color: .carbColor,
                    iconName: "leaf.fill"
                )

                MacroSummaryCard(
                    title: "Fat",
                    value: fat,
                    goal: fatGoal,
                    unit: "g",
                    color: .fatColor,
                    iconName: "drop.fill"
                )
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        MacroSummaryRow(
            protein: 87, carbs: 210, fat: 45, calories: 1650,
            proteinGoal: 150, carbsGoal: 250, fatGoal: 65
        )
        .padding()
    }
}
