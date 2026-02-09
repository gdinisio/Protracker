import SwiftUI
import Charts

struct MonthlyChartView: View {
    let logs: [DailyLog]
    let goal: Double

    private var chartData: [(date: Date, protein: Double, metGoal: Bool)] {
        let calendar = Calendar.current
        return (0...29).map { daysAgo in
            let date = calendar.startOfDay(for: Date.now.daysAgo(29 - daysAgo))
            let log = logs.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
            let protein = log?.totalProtein ?? 0
            return (date: date, protein: protein, metGoal: log?.goalMet ?? false)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 30 Days")
                .font(.subheadline.weight(.semibold))

            Chart(chartData, id: \.date) { item in
                BarMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Protein", item.protein)
                )
                .foregroundStyle(item.metGoal ? Color.green.gradient : Color.blue.opacity(0.6).gradient)
                .cornerRadius(2)

                RuleMark(y: .value("Goal", goal))
                    .foregroundStyle(.green.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [6, 4]))
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel()
                    AxisGridLine(stroke: StrokeStyle(dash: [4, 4]))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) {
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .frame(height: 220)

            HStack(spacing: 16) {
                Label("Goal met", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                Label("Below goal", systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(.blue.opacity(0.6))
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        GradientBackground()
        MonthlyChartView(logs: [], goal: 150)
            .padding()
    }
}
