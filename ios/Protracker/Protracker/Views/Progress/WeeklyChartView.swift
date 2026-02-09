import SwiftUI
import Charts

struct WeeklyChartView: View {
    let logs: [DailyLog]
    let goal: Double

    private var chartData: [(date: Date, protein: Double)] {
        let calendar = Calendar.current
        return (0...6).map { daysAgo in
            let date = calendar.startOfDay(for: Date.now.daysAgo(6 - daysAgo))
            let protein = logs.first(where: { calendar.isDate($0.date, inSameDayAs: date) })?.totalProtein ?? 0
            return (date: date, protein: protein)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 7 Days")
                .font(.subheadline.weight(.semibold))

            Chart(chartData, id: \.date) { item in
                LineMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Protein", item.protein)
                )
                .foregroundStyle(.blue.gradient)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 3))

                AreaMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Protein", item.protein)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(0.25), .blue.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Protein", item.protein)
                )
                .foregroundStyle(.blue)
                .symbolSize(item.protein > 0 ? 40 : 0)

                RuleMark(y: .value("Goal", goal))
                    .foregroundStyle(.green.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [6, 4]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Goal")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.green)
                    }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel()
                    AxisGridLine(stroke: StrokeStyle(dash: [4, 4]))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
            .frame(height: 220)
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        GradientBackground()
        WeeklyChartView(logs: [], goal: 150)
            .padding()
    }
}
