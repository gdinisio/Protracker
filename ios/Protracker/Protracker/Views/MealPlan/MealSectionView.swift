import SwiftUI

struct MealSectionView: View {
    let mealType: MealType
    let entries: [FoodLogEntry]
    let proteinTotal: Double
    var onDelete: ((FoodLogEntry) -> Void)?
    var onAddFood: (() -> Void)?

    @State private var isExpanded = true

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(duration: 0.35)) {
                    isExpanded.toggle()
                }
                HapticManager.selection()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: mealType.iconName)
                        .font(.title3)
                        .foregroundStyle(mealType.color)
                        .frame(width: 32)

                    Text(mealType.rawValue)
                        .font(.headline)

                    Spacer()

                    Text("\(proteinTotal.wholeNumber)g protein")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.proteinColor)
                        .contentTransition(.numericText())

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 0) {
                    if entries.isEmpty {
                        HStack {
                            Text("No items logged")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    } else {
                        ForEach(entries) { entry in
                            FoodLogEntryRow(entry: entry)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        onDelete?(entry)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }

                            if entry.id != entries.last?.id {
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }

                    if let onAddFood {
                        Button(action: onAddFood) {
                            Label("Add Food", systemImage: "plus")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(.glass)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        VStack(spacing: 12) {
            MealSectionView(
                mealType: .breakfast,
                entries: [],
                proteinTotal: 0
            )
            MealSectionView(
                mealType: .lunch,
                entries: [],
                proteinTotal: 45
            )
        }
        .padding()
    }
}
