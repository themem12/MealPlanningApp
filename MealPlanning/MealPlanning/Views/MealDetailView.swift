//
//  MealDetailView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 30/04/26.
//

import SwiftUI
import SwiftData

struct MealDetailView: View {

    @State private var showAddFoodSheet: Bool = false
    private let viewModel: MealDetailViewModel

    init(viewModel: MealDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack() {
            MealHeaderView(meal: viewModel.meal)
                .padding(.horizontal)
            if viewModel.meal.items.isEmpty {
                Spacer()
                EmptyMealView(mealType: viewModel.meal.type) {
                    showAddFoodSheet = true
                }
                Spacer()
            } else {
                ScrollView {
                    ForEach(viewModel.meal.items) { foodItem in
                        MealItemCardView(
                            foodItem: foodItem,
                            mealType: viewModel.meal.type
                        )
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    AddMealItemCardView(mealType: viewModel.meal.type) {
                        showAddFoodSheet = true
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }.background(AppColors.background)
            }
        }
        .background(
            viewModel.meal.type.color.opacity(0.1)
        )
        .sheet(isPresented: $showAddFoodSheet) {
            AddFoodItemView(
                viewModel: AddFoodItemViewModel(
                    mealType: viewModel.meal.type,
                    onSave: { foodItem in
                        viewModel.addFoodItem(foodItem)
                })
            )
        }
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
            }.frame(width: 130, height: 130)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.type.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                Text("Start your morning strong")
                    .font(.system(size: 18))
                    .foregroundStyle(AppColors.secondaryText)
                Text("• \(meal.items.count) foods added")
                    .font(.system(size: 14, weight: .semibold))
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
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
                Text(foodItem.portion)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.secondaryText)
            }
            .padding(.leading)
            .padding(.vertical)
            Spacer()
            Text("\(foodItem.calories) cal")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(mealType.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(mealType.color.opacity(0.12))
                )
                .padding(.trailing)
                .padding(.top)
        }
        .appCardStyle()
    }
}

private struct AddMealItemCardView: View {

    let mealType: MealType
    let newMealTapped: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(mealType.color)
                .font(.system(size: 30))
                .padding(.leading)
            VStack(alignment: .leading, spacing: 10) {
                Text("Add Food")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(mealType.color)
                Text("Add a food to your \(mealType.title)")
                    .font(.system(size: 15))
                    .foregroundStyle(AppColors.secondaryText)
            }.padding()
            Spacer()
        }
        .appSoftPointedCardStyle(
            background: mealType.color.opacity(0.1),
            strokeColor: mealType.color.opacity(0.35)
        )
        .onTapGesture {
            newMealTapped()
        }
    }
}

private struct EmptyMealView: View {

    let mealType: MealType
    let newMealTapped: () -> Void

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("No foods added yet")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                Text("Start building your \(mealType.title) by adding your first food.")
                    .font(.system(size: 18))
                    .foregroundStyle(AppColors.secondaryText)
                Button {
                    newMealTapped()
                } label: {
                    Label("Add Food", systemImage: "plus")
                        .font(.system(size: 18, weight: .semibold))
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
//    MealDetailView(
//        viewModel: MealDetailViewModel(
//            service: MockMealDataService(),
//            meal: Meal(
//                type: .breakfast,
//                items: [
//                    FoodItem(name: "Chicken", portion: "123 gr", calories: 150)
//                ]
//            )
//        )
//    )
    MealHeaderView(meal: Meal(type: .breakfast, items: []))
}
