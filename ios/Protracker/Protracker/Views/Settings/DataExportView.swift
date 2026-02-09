import SwiftUI

struct DataExportView: View {
    let viewModel: SettingsViewModel
    @State private var showClearConfirmation = false
    @State private var showShareSheet = false
    @State private var csvData = ""

    var body: some View {
        Form {
            Section("Your Data") {
                LabeledContent("Foods Logged", value: "\(viewModel.totalFoodsLogged)")
                LabeledContent("Days Tracked", value: "\(viewModel.totalDaysTracked)")
                LabeledContent("Custom Foods", value: "\(viewModel.customFoodsCount)")
            }

            Section("Export") {
                Button {
                    csvData = viewModel.exportCSV()
                    showShareSheet = true
                } label: {
                    Label("Export as CSV", systemImage: "square.and.arrow.up")
                }
            }

            Section {
                Button(role: .destructive) {
                    showClearConfirmation = true
                } label: {
                    Label("Clear All Tracking Data", systemImage: "trash.fill")
                        .foregroundStyle(.red)
                }
            } footer: {
                Text("This will delete all logged meals, water entries, and progress data. Your food database and custom foods will be preserved.")
            }
        }
        .navigationTitle("Data")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Clear All Data",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All Data", role: .destructive) {
                viewModel.clearAllData()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. All your meal logs, water tracking, and streaks will be permanently deleted.")
        }
        #if os(iOS)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(text: csvData)
        }
        #endif
    }
}

#if os(iOS)
private struct ShareSheet: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let data = text.data(using: .utf8) ?? Data()
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("protracker_export.csv")
        try? data.write(to: tempURL)
        return UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
