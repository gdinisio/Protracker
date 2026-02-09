import SwiftUI
import SwiftData

enum AppTab: Hashable {
    case dashboard
    case log
    case meals
    case progress
    case settings
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "house.fill", value: .dashboard) {
                DashboardView(selectedTab: $selectedTab)
            }

            Tab("Log", systemImage: "plus.circle.fill", value: .log) {
                NavigationStack {
                    FoodLogView()
                }
            }

            Tab("Meals", systemImage: "fork.knife", value: .meals) {
                NavigationStack {
                    MealPlanView()
                }
            }

            Tab("Progress", systemImage: "chart.line.uptrend.xyaxis", value: .progress) {
                NavigationStack {
                    ProteinProgressView()
                }
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            FoodItem.self,
            FoodLogEntry.self,
            DailyLog.self,
            WaterLogEntry.self,
            UserProfile.self,
            Achievement.self
        ], inMemory: true)
}
