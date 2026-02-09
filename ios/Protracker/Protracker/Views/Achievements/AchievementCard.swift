import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? categoryColor.opacity(0.15) : Color.secondary.opacity(0.1))
                    .frame(width: 52, height: 52)

                Image(systemName: achievement.isUnlocked ? achievement.iconName : "lock.fill")
                    .font(.title2)
                    .foregroundStyle(achievement.isUnlocked ? categoryColor : .secondary.opacity(0.5))
                    .symbolEffect(.bounce, value: achievement.isUnlocked)
            }

            Text(achievement.title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(achievement.isUnlocked ? .primary : .secondary)

            Text(achievement.achievementDescription)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)

            if achievement.isUnlocked, let date = achievement.unlockedAt {
                Text(date.shortFormatted)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .glassEffect(in: .rect(cornerRadius: 16))
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }

    private var categoryColor: Color {
        switch achievement.category {
        case "streak": .streakColor
        case "logging": .blue
        case "milestone": .purple
        default: .accent
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            AchievementCard(achievement: {
                let a = Achievement(key: "streak_7", title: "One Week Strong", description: "7-day streak", iconName: "flame.fill", category: "streak", threshold: 7)
                a.unlock()
                return a
            }())
            AchievementCard(achievement: Achievement(key: "streak_30", title: "Monthly Master", description: "30-day streak", iconName: "flame.fill", category: "streak", threshold: 30))
        }
        .padding()
    }
}
