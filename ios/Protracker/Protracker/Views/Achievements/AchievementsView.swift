import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: AchievementsViewModel?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                streakHeader
                calendarSection
                achievementsGrid
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background { GradientBackground() }
        .navigationTitle("Achievements")
        .onAppear {
            if viewModel == nil {
                viewModel = AchievementsViewModel(modelContext: modelContext)
            }
            viewModel?.loadData()
        }
    }

    // MARK: - Streak Header

    private var streakHeader: some View {
        GlassEffectContainer {
            HStack(spacing: 12) {
                streakStat(
                    value: "\(viewModel?.currentStreak ?? 0)",
                    label: "Current Streak",
                    iconName: "flame.fill",
                    color: .streakColor
                )

                streakStat(
                    value: "\(viewModel?.longestStreak ?? 0)",
                    label: "Longest Streak",
                    iconName: "trophy.fill",
                    color: .yellow
                )

                streakStat(
                    value: "\(viewModel?.unlockedCount ?? 0)/\(viewModel?.totalCount ?? 0)",
                    label: "Unlocked",
                    iconName: "star.fill",
                    color: .purple
                )
            }
        }
    }

    private func streakStat(value: String, label: String, iconName: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .contentTransition(.numericText())

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .glassEffect(in: .rect(cornerRadius: 16))
    }

    // MARK: - Calendar

    private var calendarSection: some View {
        StreakCalendarView(data: viewModel?.calendarData ?? [])
    }

    // MARK: - Achievements Grid

    private var achievementsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Achievements")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 4)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel?.achievements ?? []) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
