import SwiftData
import SwiftUI

@Observable
final class MealPlanViewModel {
    var selectedDate: Date = .now
    var dailyLog: DailyLog?
    var userProfile: UserProfile?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var totalProtein: Double { dailyLog?.totalProtein ?? 0 }
    var totalCarbs: Double { dailyLog?.totalCarbs ?? 0 }
    var totalFat: Double { dailyLog?.totalFat ?? 0 }
    var totalCalories: Double { dailyLog?.totalCalories ?? 0 }
    var proteinGoal: Double { userProfile?.dailyProteinGoal ?? 150 }

    func loadData() {
        loadProfile()
        loadDailyLog()
    }

    func entries(for mealType: MealType) -> [FoodLogEntry] {
        dailyLog?.entries(for: mealType) ?? []
    }

    func proteinTotal(for mealType: MealType) -> Double {
        dailyLog?.totalProtein(for: mealType) ?? 0
    }

    func deleteEntry(_ entry: FoodLogEntry) {
        let vm = FoodLogViewModel(modelContext: modelContext)
        vm.deleteEntry(entry)
        loadDailyLog()
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        loadDailyLog()
    }

    private func loadProfile() {
        let descriptor = FetchDescriptor<UserProfile>()
        userProfile = try? modelContext.fetch(descriptor).first
    }

    private func loadDailyLog() {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate<DailyLog> { $0.date == startOfDay }
        )
        dailyLog = try? modelContext.fetch(descriptor).first
    }
}
