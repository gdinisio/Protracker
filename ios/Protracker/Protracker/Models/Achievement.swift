import SwiftData
import Foundation

@Model
final class Achievement {
    var key: String
    var title: String
    var achievementDescription: String
    var iconName: String
    var unlockedAt: Date?
    var isUnlocked: Bool
    var category: String
    var threshold: Int

    init(
        key: String,
        title: String,
        description: String,
        iconName: String,
        category: String,
        threshold: Int
    ) {
        self.key = key
        self.title = title
        self.achievementDescription = description
        self.iconName = iconName
        self.category = category
        self.threshold = threshold
        self.isUnlocked = false
    }

    func unlock() {
        guard !isUnlocked else { return }
        isUnlocked = true
        unlockedAt = .now
    }
}
