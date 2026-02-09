import SwiftUI

struct StreakBadgeView: View {
    let streak: Int
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.red.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(.streakColor)
                        .symbolEffect(.bounce, value: streak)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(streak)")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .contentTransition(.numericText())

                        Text(streak == 1 ? "day" : "days")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

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
        VStack {
            StreakBadgeView(streak: 12)
            StreakBadgeView(streak: 0)
        }
        .padding()
    }
}
