import SwiftData
import Foundation

enum BarcodeService {
    static func lookupBarcode(_ barcode: String, context: ModelContext) -> FoodItem? {
        FoodDatabaseService.findByBarcode(barcode, context: context)
    }
}
