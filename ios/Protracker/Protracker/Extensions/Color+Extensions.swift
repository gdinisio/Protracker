import SwiftUI

extension Color {
    static let proteinColor = Color.blue
    static let carbColor = Color.orange
    static let fatColor = Color.purple
    static let waterColor = Color.cyan
    static let streakColor = Color.red
    static let successColor = Color.green

    static let gradientStart = Color.teal
    static let gradientMid = Color.blue
    static let gradientEnd = Color.indigo
}

extension ShapeStyle where Self == Color {
    static var proteinColor: Color { .proteinColor }
    static var carbColor: Color { .carbColor }
    static var fatColor: Color { .fatColor }
    static var waterColor: Color { .waterColor }
    static var streakColor: Color { .streakColor }
    static var successColor: Color { .successColor }
}
