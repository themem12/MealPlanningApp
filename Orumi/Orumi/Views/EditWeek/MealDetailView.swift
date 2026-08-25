//
//  MealDetailView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 30/04/26.
//

import SwiftUI
import SwiftData

struct MealDetailView: View {

    @State private var viewModel: MealDetailViewModel
    private let addFoodTapped: (FoodItem?) -> ()

    init(viewModel: MealDetailViewModel, addFoodTapped: @escaping (FoodItem?) -> ()) {
        self.viewModel = viewModel
        self.addFoodTapped = addFoodTapped
    }

    var body: some View {
        VStack() {
            MealHeaderView(meal: viewModel.meal)
                .padding(.horizontal)
            if viewModel.meal.items.isEmpty {
                Spacer()
                EmptyMealView(mealType: viewModel.meal.type) {
                    addFoodTapped(nil)
                }
                Spacer()
            } else {
                ScrollView {
                    ForEach(viewModel.meal.items) { foodItem in
                        Button {
                            addFoodTapped(foodItem)
                        } label: {
                            MealItemCardView(
                                foodItem: foodItem,
                                mealType: viewModel.meal.type
                            )
                        }
                        .accessibilityHint("Edit this food")
                        .padding(.horizontal)
                        .padding(.top, viewModel.meal.items.isFirst(foodItem) ? SpaceSize.medium.rawValue : SpaceSize.small.rawValue)
                        .contextMenu {
                            Button(.mealDetailViewContextEdit) {
                                addFoodTapped(foodItem)
                            }
                            Button(.mealDetailViewContextDelete, role: .destructive) {
                                viewModel.deleteFoodItemTapped(foodItem)
                            }
                        }
                    }
                    AddMealItemCardView(mealType: viewModel.meal.type) {
                        addFoodTapped(nil)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }.background(AppColors.background)
            }
        }
        .alert(
            .mealDetailViewDeleteWarningTitle,
            isPresented: $viewModel.showDeleteConfirmation
        ) {
            Button(.mealDetailViewDeleteWarningDelete, role: .destructive) {
                viewModel.deleteFoodItemConfirmed()
            }

            Button(.mealDetailViewDeleteWarningKeep, role: .cancel) { }
        } message: {
            Text(.mealDetailViewDeleteWarningMessage)
        }
        .padding(.top, 8)
        .background(
            viewModel.meal.type.color.opacity(0.1)
        )
    }
}

private struct MealHeaderView: View {

    let meal: Meal

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(meal.type.color.opacity(0.3))
                Image(systemName: meal.type.icon)
                    .font(.system(size: 70))
                    .foregroundStyle(meal.type.color)
            }
            .frame(width: 130, height: 130)
            .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.type.title)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(AppColors.primaryText)
                Text(meal.type.comment)
                    .font(.headline)
                    .foregroundStyle(AppColors.secondaryText)
                Text(.mealDetailViewFoodCounter(meal.items.count))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(meal.type.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(meal.type.color.opacity(0.15))
                    )
            }
            Spacer()
        }
    }
}

private struct MealItemCardView: View {

    let foodItem: FoodItem
    let mealType: MealType

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(foodItem.name)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AppColors.primaryText)
                Text(foodItem.portion)
                    .font(.callout)
                    .foregroundStyle(AppColors.secondaryText)
            }
            .padding(.leading)
            .padding(.vertical)
            Spacer()
        }
        .appCardStyle()
    }
}

private struct AddMealItemCardView: View {

    let mealType: MealType
    let newMealTapped: () -> Void

    var body: some View {
        Button {
            newMealTapped()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(mealType.color)
                    .font(.system(size: 30))
                    .padding(.leading)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 10) {
                    Text(.mealDetailViewAddFoodTitle)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(mealType.color)
                    Text(.mealDetailViewAddFoodSubtitle(mealType.title))
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryText)
                }.padding()
                Spacer()
            }
        }
        .appSoftPointedCardStyle(
            background: mealType.color.opacity(0.1),
            strokeColor: mealType.color.opacity(0.35)
        )
    }
}

private struct EmptyMealView: View {

    let mealType: MealType
    let newMealTapped: () -> Void

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text(.mealDetailViewEmptyMealTitle)
                    .font(.title.weight(.bold))
                    .foregroundStyle(AppColors.primaryText)
                Text(.mealDetailViewEmptyMealSubtitle(mealType.title))
                    .font(.headline)
                    .foregroundStyle(AppColors.secondaryText)
                Button {
                    newMealTapped()
                } label: {
                    Label(.mealDetailViewAddFoodTitle, systemImage: "plus")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(mealType.color)
                        )
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }
}

#Preview {
    MealHeaderView(meal: Meal(type: .breakfast, items: []))
}
