import SwiftUI

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .padding()
            .glassEffect(in: .rect(cornerRadius: cornerRadius))
    }

    func interactiveGlassCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .padding()
            .glassEffect(in: .rect(cornerRadius: cornerRadius))
            .hoverEffect()
    }

    func glassPill() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassEffect(in: .capsule)
    }
}
