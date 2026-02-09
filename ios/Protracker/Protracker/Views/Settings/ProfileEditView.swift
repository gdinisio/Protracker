import SwiftUI

struct ProfileEditView: View {
    @Bindable var profile: UserProfile
    var onSave: () -> Void

    private let dietaryOptions = [
        "None", "Vegetarian", "Vegan", "Pescatarian",
        "Keto", "Paleo", "Mediterranean", "High Protein"
    ]

    var body: some View {
        Form {
            Section("Body Measurements") {
                HStack {
                    Label("Weight", systemImage: "scalemass.fill")
                    Spacer()
                    TextField(
                        "kg",
                        value: Binding(
                            get: { profile.bodyWeightKg ?? 0 },
                            set: { profile.bodyWeightKg = $0 > 0 ? $0 : nil }
                        ),
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 80)
                    Text(profile.unitSystem == "metric" ? "kg" : "lbs")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Label("Height", systemImage: "ruler.fill")
                    Spacer()
                    TextField(
                        "cm",
                        value: Binding(
                            get: { profile.heightCm ?? 0 },
                            set: { profile.heightCm = $0 > 0 ? $0 : nil }
                        ),
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 80)
                    Text(profile.unitSystem == "metric" ? "cm" : "in")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Preferences") {
                Picker("Dietary Preference", selection: $profile.dietaryPreference) {
                    ForEach(dietaryOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                Picker("Unit System", selection: $profile.unitSystem) {
                    Text("Metric").tag("metric")
                    Text("Imperial").tag("imperial")
                }
            }

            if let weight = profile.bodyWeightKg, weight > 0 {
                Section("Recommended Protein") {
                    let low = weight * 1.6
                    let high = weight * 2.2
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Based on your weight of \(weight.oneDecimal) kg:")
                            .font(.subheadline)
                        Text("\(low.wholeNumber)g - \(high.wholeNumber)g per day")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.proteinColor)
                        Text("(1.6 - 2.2g per kg body weight)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            onSave()
        }
    }
}
