import SwiftData
import Foundation

enum StreakCalculator {
    static func currentStreak(context: ModelContext) -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.goalMet == true },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        guard let logs = try? context.fetch(descriptor) else { return 0 }

        let calendar = Calendar.current
        var streak = 0
        var expectedDate = calendar.startOfDay(for: .now)

        for log in logs {
            let logDate = calendar.startOfDay(for: log.date)
            if logDate == expectedDate {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: expectedDate) else { break }
                expectedDate = previousDay
            } else if logDate < expectedDate {
                break
            }
        }

        return streak
    }

    static func longestStreak(context: ModelContext) -> Int {
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.goalMet == true },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )

        guard let logs = try? context.fetch(descriptor) else { return 0 }

        let calendar = Calendar.current
        var longest = 0
        var current = 0
        var lastDate: Date?

        for log in logs {
            let logDate = calendar.startOfDay(for: log.date)
            if let last = lastDate {
                let daysBetween = calendar.dateComponents([.day], from: last, to: logDate).day ?? 0
                if daysBetween == 1 {
                    current += 1
                } else {
                    current = 1
                }
            } else {
                current = 1
            }
            longest = max(longest, current)
            lastDate = logDate
        }

        return longest
    }
}
