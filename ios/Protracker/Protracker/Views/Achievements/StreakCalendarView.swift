import SwiftUI

struct StreakCalendarView: View {
    let data: [(date: Date, intensity: Double)]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Activity (Last 90 Days)")
                    .font(.subheadline.weight(.semibold))

                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(data, id: \.date) { item in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(colorForIntensity(item.intensity))
                            .aspectRatio(1, contentMode: .fit)
                    }
                }

                HStack(spacing: 4) {
                    Text("Less")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { intensity in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorForIntensity(intensity))
                            .frame(width: 12, height: 12)
                    }

                    Text("More")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func colorForIntensity(_ intensity: Double) -> Color {
        if intensity == 0 {
            return Color.secondary.opacity(0.1)
        }
        return Color.green.opacity(0.2 + intensity * 0.8)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        StreakCalendarView(data: (0...89).map { i in
            (date: Date.now.daysAgo(89 - i), intensity: Double.random(in: 0...1))
        })
        .padding()
    }
}
