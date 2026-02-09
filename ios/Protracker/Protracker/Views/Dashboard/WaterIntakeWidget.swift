import SwiftUI

struct WaterIntakeWidget: View {
    let consumed: Double
    let goal: Double
    let glassCount: Int
    var onAddWater: (Double) -> Void = { _ in }

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(consumed / goal, 1.0)
    }

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 14) {
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundStyle(.waterColor)
                        .font(.title3)

                    Text("Water Intake")
                        .font(.subheadline.weight(.semibold))

                    Spacer()

                    Text("\(consumed.wholeNumber) / \(goal.wholeNumber) ml")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.secondary.opacity(0.15))
                            .frame(height: 10)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 10)
                            .animation(.spring(duration: 0.5), value: progress)
                    }
                }
                .frame(height: 10)

                HStack(spacing: 10) {
                    WaterQuickButton(amount: 250, label: "1 Glass") {
                        onAddWater(250)
                    }
                    WaterQuickButton(amount: 500, label: "2 Glasses") {
                        onAddWater(500)
                    }
                    WaterQuickButton(amount: 750, label: "Bottle") {
                        onAddWater(750)
                    }
                }
            }
        }
    }
}

private struct WaterQuickButton: View {
    let amount: Double
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("+\(Int(amount))ml")
                    .font(.caption.weight(.semibold))
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.glass)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        WaterIntakeWidget(consumed: 1250, goal: 2500, glassCount: 5)
            .padding()
    }
}
