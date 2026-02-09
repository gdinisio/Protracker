import SwiftUI
import SwiftData

enum TimeRange: String, CaseIterable, Identifiable {
    case daily = "Today"
    case weekly = "Week"
    case monthly = "Month"
    var id: String { rawValue }
}

struct ProteinProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ProgressViewModel?
    @State private var selectedRange: TimeRange = .weekly

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                timeRangePicker
                chartSection
                summarySection
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background { GradientBackground() }
        .navigationTitle("Progress")
        .onAppear {
            if viewModel == nil {
                viewModel = ProgressViewModel(modelContext: modelContext)
            }
            viewModel?.loadData()
        }
    }

    // MARK: - Time Range Picker

    private var timeRangePicker: some View {
        Picker("Time Range", selection: $selectedRange) {
            ForEach(TimeRange.allCases) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Chart

    @ViewBuilder
    private var chartSection: some View {
        switch selectedRange {
        case .daily:
            DailyChartView(
                log: viewModel?.todayLog,
                goal: viewModel?.proteinGoal ?? 150
            )
        case .weekly:
            WeeklyChartView(
                logs: viewModel?.weeklyLogs ?? [],
                goal: viewModel?.proteinGoal ?? 150
            )
        case .monthly:
            MonthlyChartView(
                logs: viewModel?.monthlyLogs ?? [],
                goal: viewModel?.proteinGoal ?? 150
            )
        }
    }

    // MARK: - Summary

    private var summarySection: some View {
        ProgressSummaryCard(
            averageProtein: viewModel?.averageProtein ?? 0,
            bestDay: viewModel?.bestDayProtein ?? 0,
            goalHitRate: viewModel?.goalHitRate ?? 0,
            streak: viewModel?.currentStreak ?? 0
        )
    }
}

#Preview {
    NavigationStack {
        ProteinProgressView()
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
