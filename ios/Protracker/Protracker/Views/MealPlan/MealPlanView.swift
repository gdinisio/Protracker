import SwiftUI
import SwiftData

struct MealPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: MealPlanViewModel?
    @State private var addMealType: MealType?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                dateStripSection
                dailySummaryCard
                mealSections
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background { GradientBackground() }
        .navigationTitle("Meals")
        .onAppear {
            if viewModel == nil {
                viewModel = MealPlanViewModel(modelContext: modelContext)
            }
            viewModel?.loadData()
        }
        .sheet(item: $addMealType) { meal in
            AddToMealSheet(mealType: meal)
        }
    }

    // MARK: - Date Strip

    private var dateStripSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(-6...0, id: \.self) { offset in
                    let date = Date.now.daysAgo(-offset)
                    DateChip(
                        date: date,
                        isSelected: date.isSameDay(as: viewModel?.selectedDate ?? .now)
                    ) {
                        withAnimation(.spring(duration: 0.3)) {
                            viewModel?.selectDate(date)
                        }
                        HapticManager.selection()
                    }
                }
            }
        }
    }

    // MARK: - Daily Summary

    private var dailySummaryCard: some View {
        GlassCard(cornerRadius: 20) {
            HStack(spacing: 20) {
                SummaryPill(
                    label: "Protein",
                    value: "\(viewModel?.totalProtein.wholeNumber ?? "0")g",
                    color: .proteinColor
                )
                SummaryPill(
                    label: "Carbs",
                    value: "\(viewModel?.totalCarbs.wholeNumber ?? "0")g",
                    color: .carbColor
                )
                SummaryPill(
                    label: "Fat",
                    value: "\(viewModel?.totalFat.wholeNumber ?? "0")g",
                    color: .fatColor
                )
                SummaryPill(
                    label: "Calories",
                    value: viewModel?.totalCalories.formattedCalories ?? "0",
                    color: .orange
                )
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Meal Sections

    private var mealSections: some View {
        VStack(spacing: 12) {
            ForEach(MealType.allCases) { meal in
                MealSectionView(
                    mealType: meal,
                    entries: viewModel?.entries(for: meal) ?? [],
                    proteinTotal: viewModel?.proteinTotal(for: meal) ?? 0,
                    onDelete: { entry in
                        viewModel?.deleteEntry(entry)
                    },
                    onAddFood: {
                        addMealType = meal
                    }
                )
            }
        }
    }
}

// MARK: - Supporting Views

private struct DateChip: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(date.weekdayShort)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isSelected ? .primary : .secondary)

                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.body.weight(isSelected ? .bold : .regular))
            }
            .frame(width: 48, height: 56)
        }
        .buttonStyle(.glass)
        .opacity(isSelected ? 1.0 : 0.5)
    }
}

private struct SummaryPill: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.subheadline.weight(.bold).monospacedDigit())
                .contentTransition(.numericText())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        MealPlanView()
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
