import SwiftUI

struct AnimatedRingView: View {
    let progress: Double
    let lineWidth: CGFloat
    let gradient: AngularGradient
    let size: CGFloat

    @State private var animatedProgress: Double = 0

    init(
        progress: Double,
        lineWidth: CGFloat = 20,
        size: CGFloat = 200,
        gradient: AngularGradient = AngularGradient(
            colors: [.blue, .cyan, .teal, .blue],
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
        )
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.gradient = gradient
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))

            if animatedProgress > 0 {
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: lineWidth * 0.5, height: lineWidth * 0.5)
                    .offset(y: -size / 2)
                    .rotationEffect(.degrees(360 * animatedProgress - 90))
                    .shadow(color: .white.opacity(0.6), radius: 4)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(duration: 1.2, bounce: 0.2)) {
                animatedProgress = min(progress, 1.0)
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(duration: 0.6, bounce: 0.15)) {
                animatedProgress = min(newValue, 1.0)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AnimatedRingView(progress: 0.72)
    }
}
