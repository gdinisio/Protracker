import SwiftData
import Foundation

enum DataSeeder {
    static func seedIfNeeded(context: ModelContext) {
        seedFoods(context: context)
        seedUserProfile(context: context)
        seedAchievements(context: context)
    }

    private static func seedFoods(context: ModelContext) {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { $0.isCustom == false }
        )
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        guard let url = Bundle.main.url(forResource: "FoodDatabase", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let foods = try? JSONDecoder().decode([SeedFood].self, from: data) else {
            return
        }

        for food in foods {
            let item = FoodItem(
                name: food.name,
                brand: food.brand,
                servingSize: food.servingSize,
                servingUnit: food.servingUnit,
                proteinPerServing: food.protein,
                carbsPerServing: food.carbs,
                fatPerServing: food.fat,
                caloriesPerServing: food.calories,
                category: food.category
            )
            context.insert(item)
        }
    }

    private static func seedUserProfile(context: ModelContext) {
        let descriptor = FetchDescriptor<UserProfile>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let profile = UserProfile()
        context.insert(profile)
    }

    private static func seedAchievements(context: ModelContext) {
        let descriptor = FetchDescriptor<Achievement>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let achievements: [(key: String, title: String, desc: String, icon: String, cat: String, threshold: Int)] = [
            ("streak_3", "Getting Started", "Maintain a 3-day protein goal streak", "flame.fill", "streak", 3),
            ("streak_7", "One Week Strong", "Maintain a 7-day protein goal streak", "flame.fill", "streak", 7),
            ("streak_14", "Two Weeks Champion", "Maintain a 14-day protein goal streak", "flame.fill", "streak", 14),
            ("streak_30", "Monthly Master", "Maintain a 30-day protein goal streak", "flame.fill", "streak", 30),
            ("streak_100", "Century Club", "Maintain a 100-day protein goal streak", "flame.fill", "streak", 100),
            ("logs_10", "First Steps", "Log 10 food entries", "plus.circle.fill", "logging", 10),
            ("logs_50", "Consistent Logger", "Log 50 food entries", "plus.circle.fill", "logging", 50),
            ("logs_100", "Dedicated Tracker", "Log 100 food entries", "plus.circle.fill", "logging", 100),
            ("logs_500", "Tracking Pro", "Log 500 food entries", "plus.circle.fill", "logging", 500),
            ("logs_1000", "Legendary Logger", "Log 1000 food entries", "star.fill", "logging", 1000),
            ("custom_food", "Food Creator", "Create your first custom food", "fork.knife", "milestone", 1),
            ("first_scan", "Scanner Pro", "Scan your first barcode", "barcode.viewfinder", "milestone", 1),
            ("water_7", "Hydration Hero", "Meet your water goal for 7 days", "drop.fill", "milestone", 7),
            ("protein_200", "Protein Beast", "Hit 200g protein in a single day", "bolt.fill", "milestone", 200),
        ]

        for a in achievements {
            let achievement = Achievement(
                key: a.key,
                title: a.title,
                description: a.desc,
                iconName: a.icon,
                category: a.cat,
                threshold: a.threshold
            )
            context.insert(achievement)
        }
    }
}

private struct SeedFood: Decodable {
    let name: String
    let brand: String?
    let servingSize: Double
    let servingUnit: String
    let protein: Double
    let carbs: Double
    let fat: Double
    let calories: Double
    let category: String
}
