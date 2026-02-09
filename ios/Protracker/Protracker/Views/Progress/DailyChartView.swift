import SwiftUI
import Charts

struct DailyChartView: View {
    let log: DailyLog?
    let goal: Double

    private var mealData: [(meal: String, protein: Double, color: Color)] {
        MealType.allCases.map { meal in
            (
                meal: meal.rawValue,
                protein: log?.totalProtein(for: meal) ?? 0,
                color: meal.color
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Breakdown")
                .font(.subheadline.weight(.semibold))

            if mealData.allSatisfy({ $0.protein == 0 }) {
                emptyChart
            } else {
                Chart(mealData, id: \.meal) { item in
                    BarMark(
                        x: .value("Meal", item.meal),
                        y: .value("Protein", item.protein)
                    )
                    .foregroundStyle(item.color.gradient)
                    .cornerRadius(6)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) {
                        AxisValueLabel()
                        AxisGridLine(stroke: StrokeStyle(dash: [4, 4]))
                    }
                }
                .chartYAxisLabel("grams", position: .leading)
                .frame(height: 200)
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }

    private var emptyChart: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.fill")
                .font(.title)
                .foregroundStyle(.secondary)
            Text("No meals logged today")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        DailyChartView(log: nil, goal: 150)
            .padding()
    }
}
