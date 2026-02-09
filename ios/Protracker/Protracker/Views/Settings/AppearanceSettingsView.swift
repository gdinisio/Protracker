import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("appColorScheme") private var appColorScheme = "system"

    var body: some View {
        Form {
            Section("Theme") {
                Picker("Appearance", selection: $appColorScheme) {
                    Label("System", systemImage: "circle.lefthalf.filled").tag("system")
                    Label("Light", systemImage: "sun.max.fill").tag("light")
                    Label("Dark", systemImage: "moon.fill").tag("dark")
                }
                .pickerStyle(.inline)
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Liquid Glass adapts beautifully to both light and dark mode. The system setting is recommended for the best experience.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppearanceSettingsView()
    }
}
