import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTab: AppTab
    @State private var viewModel: DashboardViewModel?
    @State private var showQuickAddSheet = false
    @State private var selectedQuickAddFood: FoodItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    proteinRingSection
                    macroSection
                    mealsSection
                    waterSection
                    streakSection
                    quickAddSection
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background { GradientBackground() }
            .navigationTitle("Dashboard")
            .refreshable {
                viewModel?.loadData()
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = DashboardViewModel(modelContext: modelContext)
                }
                viewModel?.loadData()
            }
            .sheet(item: $selectedQuickAddFood) { food in
                NavigationStack {
                    FoodDetailView(foodItem: food)
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.title2.weight(.bold))

            Text(Date.now.fullFormatted)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }

    // MARK: - Protein Ring

    private var proteinRingSection: some View {
        Button {
            selectedTab = .progress
        } label: {
            ProteinRingView(
                consumed: viewModel?.proteinConsumed ?? 0,
                goal: viewModel?.proteinGoal ?? 150,
                progress: viewModel?.proteinProgress ?? 0
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Macros

    private var macroSection: some View {
        MacroSummaryRow(
            protein: viewModel?.proteinConsumed ?? 0,
            carbs: viewModel?.carbsConsumed ?? 0,
            fat: viewModel?.fatConsumed ?? 0,
            calories: viewModel?.caloriesConsumed ?? 0,
            proteinGoal: viewModel?.userProfile?.dailyProteinGoal ?? 150,
            carbsGoal: viewModel?.userProfile?.dailyCarbsGoal ?? 250,
            fatGoal: viewModel?.userProfile?.dailyFatGoal ?? 65
        )
    }

    // MARK: - Meals

    private var mealsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Today's Meals")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(viewModel?.caloriesConsumed.formattedCalories ?? "0") kcal")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)

            ForEach(MealType.allCases) { meal in
                MealSummaryRow(
                    mealType: meal,
                    proteinAmount: viewModel?.todayLog?.totalProtein(for: meal) ?? 0,
                    entryCount: viewModel?.todayLog?.entries(for: meal).count ?? 0
                ) {
                    selectedTab = .meals
                }
            }
        }
    }

    // MARK: - Water

    private var waterSection: some View {
        WaterIntakeWidget(
            consumed: viewModel?.waterConsumed ?? 0,
            goal: viewModel?.waterGoal ?? 2500,
            glassCount: viewModel?.waterGlasses ?? 0
        ) { ml in
            viewModel?.addWater(ml: ml)
        }
    }

    // MARK: - Streak

    private var streakSection: some View {
        StreakBadgeView(streak: viewModel?.currentStreak ?? 0) {
            selectedTab = .settings
        }
    }

    // MARK: - Quick Add

    private var quickAddSection: some View {
        QuickAddBar(favorites: viewModel?.recentFavorites ?? []) { food in
            selectedQuickAddFood = food
        }
    }
}

#Preview {
    @Previewable @State var tab: AppTab = .dashboard
    ContentView()
        .modelContainer(for: [
            FoodItem.self, FoodLogEntry.self, DailyLog.self,
            WaterLogEntry.self, UserProfile.self, Achievement.self
        ], inMemory: true)
}
