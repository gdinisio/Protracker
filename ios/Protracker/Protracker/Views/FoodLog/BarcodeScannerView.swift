#if canImport(VisionKit)
import SwiftUI
import VisionKit

struct BarcodeScannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var scannedCode: String?
    @State private var foundFood: FoodItem?
    @State private var showNotFound = false
    @State private var showCustomFoodForm = false

    var body: some View {
        NavigationStack {
            ZStack {
                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                    DataScannerRepresentable(onBarcodeFound: handleBarcode)
                        .ignoresSafeArea()
                } else {
                    unsupportedView
                }

                VStack {
                    Spacer()
                    scanOverlay
                }
            }
            .navigationTitle("Scan Barcode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(item: $foundFood) { food in
                NavigationStack {
                    FoodDetailView(foodItem: food)
                }
            }
            .sheet(isPresented: $showCustomFoodForm) {
                NavigationStack {
                    CustomFoodFormView()
                }
            }
            .alert("Food Not Found", isPresented: $showNotFound) {
                Button("Create Custom Food") {
                    showCustomFoodForm = true
                }
                Button("Try Again", role: .cancel) {
                    scannedCode = nil
                }
            } message: {
                Text("No food found for barcode \(scannedCode ?? ""). Would you like to create a custom entry?")
            }
        }
    }

    private var unsupportedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Barcode scanning is not available on this device.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var scanOverlay: some View {
        VStack(spacing: 8) {
            if scannedCode == nil {
                Label("Point camera at a barcode", systemImage: "viewfinder")
                    .font(.subheadline.weight(.medium))
                    .glassPill()
            } else {
                Label("Barcode: \(scannedCode ?? "")", systemImage: "checkmark.circle.fill")
                    .font(.subheadline.weight(.medium))
                    .glassPill()
            }
        }
        .padding(.bottom, 40)
    }

    private func handleBarcode(_ code: String) {
        guard scannedCode == nil else { return }
        scannedCode = code
        HapticManager.notification(.success)

        if let food = FoodDatabaseService.findByBarcode(code, context: modelContext) {
            foundFood = food
        } else {
            showNotFound = true
        }
    }
}

struct DataScannerRepresentable: UIViewControllerRepresentable {
    let onBarcodeFound: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        try? scanner.startScanning()
        return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onBarcodeFound: onBarcodeFound)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onBarcodeFound: (String) -> Void

        init(onBarcodeFound: @escaping (String) -> Void) {
            self.onBarcodeFound = onBarcodeFound
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in addedItems {
                if case .barcode(let barcode) = item,
                   let value = barcode.payloadStringValue {
                    Task { @MainActor in
                        onBarcodeFound(value)
                    }
                }
            }
        }
    }
}

#endif
