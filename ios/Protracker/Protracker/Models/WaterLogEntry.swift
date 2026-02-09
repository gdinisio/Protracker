import SwiftData
import Foundation

@Model
final class WaterLogEntry {
    var amountML: Double
    var loggedAt: Date
    var dailyLog: DailyLog?

    init(amountML: Double, loggedAt: Date = .now) {
        self.amountML = amountML
        self.loggedAt = loggedAt
    }
}
