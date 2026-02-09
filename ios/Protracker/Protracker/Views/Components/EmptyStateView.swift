import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .symbolEffect(.pulse.wholeSymbol)

            Text(title)
                .font(.title3.weight(.semibold))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.glassProminent)
                    .padding(.top, 4)
            }
        }
        .padding(32)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        EmptyStateView(
            iconName: "fork.knife",
            title: "No Meals Logged",
            message: "Start logging your meals to track your protein intake throughout the day.",
            actionTitle: "Log Food"
        ) {
            // action
        }
    }
}
