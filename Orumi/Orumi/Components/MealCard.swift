//
//  MealCard.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 11/06/26.
//

import SwiftUI

struct MealCard: View {
    private let hasItems: Bool
    private let meal: Meal
    private let isRecord: Bool

    init(meal: Meal, isRecord: Bool = false) {
        self.hasItems = !meal.items.isEmpty
        self.meal = meal
        self.isRecord = isRecord
    }

    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(meal.type.color)
                .frame(width: 6)
            ZStack {
                Circle()
                    .fill(
                        meal.type.color.opacity(
                            hasItems ? 0.15 : 0.1
                        )
                    )
                    .frame(
                        width: 48,
                        height: 48
                    )
                Image(systemName: meal.type.icon)
                    .foregroundStyle(
                        meal.type.color.opacity(hasItems ? 1 : 0.55)
                    )
                    .font(.title.weight(.semibold))
            }.padding(.top)
            VStack(alignment: .leading) {
                Text(meal.type.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(AppColors.primaryText)
                    .accessibilitySortPriority(1)
                if !hasItems {
                    Text(.mealCardAddFoods)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(AppColors.secondaryText.opacity(0.7))
                } else {
                    Grid(alignment: .leading, horizontalSpacing: 40) {
                        ForEach(meal.items.sorted(by: { $0.name < $1.name })) { item in
                            GridRow {
                                HStack {
                                    Text("•")
                                        .foregroundStyle(meal.type.color)
                                    Text(item.name)
                                        .font(.footnote.weight(.light))
                                        .foregroundStyle(AppColors.secondaryText)
                                }
                                Text(item.portion)
                                    .font(.footnote)
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                    }
                }
            }
            .padding()
            Spacer()
            if isRecord {
                Group {
                    if !hasItems {
                        Image(systemName: "circle")
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .font(.system(size: 30))
                    } else {
                        if meal.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(AppColors.lunch)
                                .font(.system(size: 30))
                        } else {
                            Image(systemName: "circle")
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .font(.system(size: 30))
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding(.trailing)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .appCardStyle()
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    let meal = Meal(
        type: .breakfast,
        items: [
            .init(name: "Pollo", portion: "123 gr"),
            .init(name: "Pan integral", portion: "3 piezas"),
            .init(name: "Frijoles", portion: "1 taza"),
        ]
    )
    meal.isCompleted = true
    return MealCard(
        meal: meal,
        isRecord: true
    )
}
