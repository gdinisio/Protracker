import SwiftUI

struct ProgressSummaryCard: View {
    let averageProtein: Double
    let bestDay: Double
    let goalHitRate: Double
    let streak: Int

    var body: some View {
        GlassEffectContainer {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                StatCard(
                    title: "Avg. Daily Protein",
                    value: "\(averageProtein.wholeNumber)g",
                    iconName: "chart.line.flattrend.xyaxis",
                    color: .proteinColor
                )

                StatCard(
                    title: "Best Day",
                    value: "\(bestDay.wholeNumber)g",
                    iconName: "trophy.fill",
                    color: .yellow
                )

                StatCard(
                    title: "Goal Hit Rate",
                    value: "\(goalHitRate.wholeNumber)%",
                    iconName: "target",
                    color: .green
                )

                StatCard(
                    title: "Current Streak",
                    value: "\(streak) day\(streak == 1 ? "" : "s")",
                    iconName: "flame.fill",
                    color: .streakColor
                )
            }
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.headline.monospacedDigit())
                .contentTransition(.numericText())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        GradientBackground()
        ProgressSummaryCard(
            averageProtein: 132,
            bestDay: 187,
            goalHitRate: 71,
            streak: 5
        )
        .padding()
    }
}
