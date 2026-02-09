import SwiftUI

struct ProteinRingView: View {
    let consumed: Double
    let goal: Double
    let progress: Double

    var body: some View {
        GlassCard(cornerRadius: 28) {
            VStack(spacing: 16) {
                ZStack {
                    AnimatedRingView(
                        progress: progress,
                        lineWidth: 22,
                        size: 180,
                        gradient: AngularGradient(
                            colors: [.blue, .cyan, .teal, .green, .blue],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        )
                    )

                    VStack(spacing: 4) {
                        Text("\(Int(min(progress * 100, 999)))%")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())

                        Text("\(consumed.wholeNumber)g / \(goal.wholeNumber)g")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 24) {
                    VStack(spacing: 2) {
                        Text(consumed.wholeNumber)
                            .font(.title3.weight(.bold).monospacedDigit())
                            .contentTransition(.numericText())
                        Text("consumed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Rectangle()
                        .fill(.secondary.opacity(0.3))
                        .frame(width: 1, height: 30)

                    VStack(spacing: 2) {
                        Text(max(0, goal - consumed).wholeNumber)
                            .font(.title3.weight(.bold).monospacedDigit())
                            .contentTransition(.numericText())
                        Text("remaining")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        ProteinRingView(consumed: 87, goal: 150, progress: 0.58)
            .padding()
    }
}
