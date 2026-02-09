import SwiftUI

struct GradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.5, 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: colorScheme == .dark ? darkColors : lightColors
        )
        .ignoresSafeArea()
    }

    private var darkColors: [Color] {
        [
            .indigo.opacity(0.8), .purple.opacity(0.6), .blue.opacity(0.7),
            .teal.opacity(0.5), .cyan.opacity(0.4), .blue.opacity(0.6),
            .mint.opacity(0.4), .teal.opacity(0.5), .indigo.opacity(0.7)
        ]
    }

    private var lightColors: [Color] {
        [
            .cyan.opacity(0.25), .teal.opacity(0.2), .blue.opacity(0.15),
            .mint.opacity(0.2), .white.opacity(0.9), .purple.opacity(0.15),
            .blue.opacity(0.15), .teal.opacity(0.2), .cyan.opacity(0.2)
        ]
    }
}

#Preview {
    GradientBackground()
}
