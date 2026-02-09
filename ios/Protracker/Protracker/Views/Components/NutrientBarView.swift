import SwiftUI

struct NutrientBarView: View {
    let label: String
    let current: Double
    let goal: Double
    let color: Color
    let unit: String

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(current.wholeNumber) / \(goal.wholeNumber)\(unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 8)

                    Capsule()
                        .fill(color.gradient)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NutrientBarView(label: "Protein", current: 87, goal: 150, color: .blue, unit: "g")
        NutrientBarView(label: "Carbs", current: 210, goal: 250, color: .orange, unit: "g")
        NutrientBarView(label: "Fat", current: 45, goal: 65, color: .purple, unit: "g")
    }
    .padding()
}
