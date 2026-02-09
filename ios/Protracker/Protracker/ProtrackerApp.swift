import SwiftUI
import SwiftData

@main
struct ProtrackerApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                FoodItem.self,
                FoodLogEntry.self,
                DailyLog.self,
                WaterLogEntry.self,
                UserProfile.self,
                Achievement.self
            ])
            let config = ModelConfiguration(schema: schema)
            modelContainer = try ModelContainer(for: schema, configurations: [config])

            DataSeeder.seedIfNeeded(context: modelContainer.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
