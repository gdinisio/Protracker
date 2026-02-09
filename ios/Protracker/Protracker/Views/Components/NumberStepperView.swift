import SwiftUI

struct NumberStepperView: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let label: String
    let unit: String

    init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0.5...20,
        step: Double = 0.5,
        label: String = "Servings",
        unit: String = ""
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.unit = unit
    }

    var body: some View {
        HStack(spacing: 16) {
            Text(label)
                .font(.subheadline.weight(.medium))

            Spacer()

            HStack(spacing: 12) {
                Button {
                    let newValue = value - step
                    if newValue >= range.lowerBound {
                        value = newValue
                        HapticManager.selection()
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.body.weight(.semibold))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.glass)
                .disabled(value <= range.lowerBound)

                Text("\(value.oneDecimal)\(unit)")
                    .font(.title3.weight(.semibold).monospacedDigit())
                    .frame(minWidth: 60)
                    .contentTransition(.numericText())

                Button {
                    let newValue = value + step
                    if newValue <= range.upperBound {
                        value = newValue
                        HapticManager.selection()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.glass)
                .disabled(value >= range.upperBound)
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Double = 1.0
    ZStack {
        GradientBackground()
        NumberStepperView(value: $value)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 20))
    }
}
