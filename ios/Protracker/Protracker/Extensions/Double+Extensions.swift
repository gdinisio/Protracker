import Foundation

extension Double {
    var wholeNumber: String {
        String(format: "%.0f", self)
    }

    var oneDecimal: String {
        String(format: "%.1f", self)
    }

    var formattedCalories: String {
        if self >= 1000 {
            return String(format: "%.1fk", self / 1000)
        }
        return wholeNumber
    }

    var formattedGrams: String {
        if self >= 100 {
            return wholeNumber + "g"
        }
        return oneDecimal + "g"
    }

    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
