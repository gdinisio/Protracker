import SwiftUI

struct GoalSettingView: View {
    @Bindable var profile: UserProfile
    var onSave: () -> Void

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Protein", systemImage: "flame.fill")
                            .foregroundStyle(.proteinColor)
                        Spacer()
                        Text("\(Int(profile.dailyProteinGoal))g")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .foregroundStyle(.proteinColor)
                            .contentTransition(.numericText())
                    }
                    Slider(value: $profile.dailyProteinGoal, in: 50...400, step: 5)
                        .tint(.proteinColor)
                }
            } header: {
                Text("Daily Protein Goal")
            } footer: {
                Text("Recommended: 1.6-2.2g per kg of body weight for muscle building.")
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Carbs", systemImage: "leaf.fill")
                            .foregroundStyle(.carbColor)
                        Spacer()
                        Text("\(Int(profile.dailyCarbsGoal))g")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .foregroundStyle(.carbColor)
                            .contentTransition(.numericText())
                    }
                    Slider(value: $profile.dailyCarbsGoal, in: 50...500, step: 10)
                        .tint(.carbColor)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Fat", systemImage: "drop.fill")
                            .foregroundStyle(.fatColor)
                        Spacer()
                        Text("\(Int(profile.dailyFatGoal))g")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .foregroundStyle(.fatColor)
                            .contentTransition(.numericText())
                    }
                    Slider(value: $profile.dailyFatGoal, in: 20...200, step: 5)
                        .tint(.fatColor)
                }
            } header: {
                Text("Macro Goals")
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Calories", systemImage: "bolt.fill")
                            .foregroundStyle(.orange)
                        Spacer()
                        Text("\(Int(profile.dailyCalorieGoal)) kcal")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .foregroundStyle(.orange)
                            .contentTransition(.numericText())
                    }
                    Slider(value: $profile.dailyCalorieGoal, in: 1000...5000, step: 50)
                        .tint(.orange)
                }
            } header: {
                Text("Calorie Goal")
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Water", systemImage: "drop.fill")
                            .foregroundStyle(.waterColor)
                        Spacer()
                        Text("\(Int(profile.dailyWaterGoalML)) ml")
                            .font(.title2.weight(.bold).monospacedDigit())
                            .foregroundStyle(.waterColor)
                            .contentTransition(.numericText())
                    }
                    Slider(value: $profile.dailyWaterGoalML, in: 1000...5000, step: 100)
                        .tint(.waterColor)
                }
            } header: {
                Text("Water Goal")
            } footer: {
                Text("General recommendation: 2000-3000ml per day.")
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            onSave()
        }
    }
}
