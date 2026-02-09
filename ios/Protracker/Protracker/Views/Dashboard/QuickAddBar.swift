import SwiftUI

struct QuickAddBar: View {
    let favorites: [FoodItem]
    var onSelect: (FoodItem) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Add")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 4)

            if favorites.isEmpty {
                Text("Star your favorite foods for quick access")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(favorites) { food in
                            Button {
                                onSelect(food)
                            } label: {
                                HStack(spacing: 6) {
                                    Text(food.name)
                                        .font(.caption.weight(.medium))
                                        .lineLimit(1)

                                    Text("\(food.proteinPerServing.wholeNumber)g")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.proteinColor)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.glass)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        QuickAddBar(favorites: [])
            .padding()
    }
}
