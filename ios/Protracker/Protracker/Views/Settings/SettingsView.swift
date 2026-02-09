import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SettingsViewModel?

    var body: some View {
        Form {
            if let profile = viewModel?.userProfile {
                profileSection(profile)
                goalsSection(profile)
            }

            appearanceSection
            achievementsSection
            dataSection
            aboutSection
        }
        .navigationTitle("Settings")
        .onAppear {
            if viewModel == nil {
                viewModel = SettingsViewModel(modelContext: modelContext)
            }
            viewModel?.loadData()
        }
    }

    // MARK: - Profile

    private func profileSection(_ profile: UserProfile) -> some View {
        Section {
            NavigationLink {
                ProfileEditView(profile: profile) {
                    viewModel?.saveProfile()
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(.accent.opacity(0.15))
                            .frame(width: 48, height: 48)

                        Image(systemName: "person.fill")
                            .font(.title3)
                            .foregroundStyle(.accent)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Profile")
                            .font(.body.weight(.medium))

                        HStack(spacing: 8) {
                            if let weight = profile.bodyWeightKg {
                                Text("\(weight.oneDecimal) kg")
                            }
                            if profile.dietaryPreference != "None" {
                                Text(profile.dietaryPreference)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Goals

    private func goalsSection(_ profile: UserProfile) -> some View {
        Section("Daily Goals") {
            NavigationLink {
                GoalSettingView(profile: profile) {
                    viewModel?.saveProfile()
                }
            } label: {
                Label {
                    HStack {
                        Text("Protein Goal")
                        Spacer()
                        Text("\(Int(profile.dailyProteinGoal))g")
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.proteinColor)
                }
            }

            NavigationLink {
                GoalSettingView(profile: profile) {
                    viewModel?.saveProfile()
                }
            } label: {
                Label {
                    HStack {
                        Text("Calorie Goal")
                        Spacer()
                        Text("\(Int(profile.dailyCalorieGoal)) kcal")
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(.orange)
                }
            }

            NavigationLink {
                GoalSettingView(profile: profile) {
                    viewModel?.saveProfile()
                }
            } label: {
                Label {
                    HStack {
                        Text("Water Goal")
                        Spacer()
                        Text("\(Int(profile.dailyWaterGoalML)) ml")
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "drop.fill")
                        .foregroundStyle(.waterColor)
                }
            }
        }
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        Section {
            NavigationLink {
                AppearanceSettingsView()
            } label: {
                Label("Appearance", systemImage: "paintbrush.fill")
            }
        }
    }

    // MARK: - Achievements

    private var achievementsSection: some View {
        Section {
            NavigationLink {
                AchievementsView()
            } label: {
                Label("Achievements", systemImage: "trophy.fill")
            }
        }
    }

    // MARK: - Data

    private var dataSection: some View {
        Section {
            if let viewModel {
                NavigationLink {
                    DataExportView(viewModel: viewModel)
                } label: {
                    Label("Data & Export", systemImage: "externaldrive.fill")
                }
            }
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section {
            LabeledContent("Version", value: "1.0")
            LabeledContent("Build", value: "1")
        } header: {
            Text("About")
        } footer: {
            Text("Protracker - Your protein tracking companion.")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(for: [
        FoodItem.self, FoodLogEntry.self, DailyLog.self,
        WaterLogEntry.self, UserProfile.self, Achievement.self
    ], inMemory: true)
}
