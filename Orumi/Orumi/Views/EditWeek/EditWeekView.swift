//
//  EditWeekView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 30/04/26.
//

import SwiftUI

struct EditWeekView: View {

    @State private var viewModel: EditWeekViewModel
    @State private var selectedMeal: Meal?

    init(viewModel: EditWeekViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading){
            Group{
                Text(.editWeekViewTitle)
                    .font(.largeTitle)
                    .foregroundStyle(AppColors.primaryText)
                Text(.editWeekViewSubtitle)
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(AppColors.secondaryText)
            }.padding(.horizontal)

            ScrollView {
                ForEach(WeekDay.orderedCases) { weekDay in
                    DayCardView(
                        weekDay: weekDay,
                        isSelected: viewModel.dayIsSelected(weekDay),
                        isToday: viewModel.isCurrentDay(weekDay),
                        mealsCount: viewModel.getMealsCountFor(weekDay: weekDay),
                        meals: viewModel.getMealsFor(weekDay: weekDay),
                        selectDay: {
                            viewModel.selectDay(weekDay)
                        },
                        mealTapped: { mealTapped in
                            withAnimation(.easeInOut) {
                                selectedMeal = mealTapped
                            }
                        }
                    )
                    .padding(.top)
                    .padding(.horizontal)
                }
            }
        }
        .navigationDestination(item: $selectedMeal) { meal in
            MealDetailView(
                viewModel: viewModel.makeMealDetailViewModel(for: meal)
            ) { foodItem in
                viewModel.foodItemTapped(foodItem: foodItem, meal: meal)
            }
        }
        .background(AppColors.background)
        .sheet(isPresented: $viewModel.addFoodTapped) {
            FoodItemView(viewModel: viewModel.getFoodItemViewModel())
        }
    }
}

private struct DayCardView: View {
    
    let weekDay: WeekDay
    let isSelected: Bool
    let isToday: Bool
    let mealsCount: Int
    let meals: [Meal]
    let selectDay: () -> Void
    let mealTapped: (Meal) -> Void

    @State private var selectedMeal: Meal?
    
    var body: some View {
        VStack {
            Button {
                selectDay()
            } label: {
                HeaderCardView(
                    mealsCount: mealsCount,
                    weekDay: weekDay,
                    isSelected: isSelected,
                    isToday: isToday
                )
            }.buttonStyle(.plain)
            if isSelected {
                MealsCardView(
                    meals: meals,
                    mealTapped: mealTapped
                ).padding(.bottom, 8)
            }
        }
        .padding(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .appCardStyle()
    }
}

private struct HeaderCardView: View {
    
    let mealsCount: Int
    let weekDay: WeekDay
    let isSelected: Bool
    let isToday: Bool
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.softSage)
                    .frame(width: 40, height: 40)
                Text(weekDay.shortTitle)
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.primaryText)
            }
            VStack(alignment: .leading) {
                Text(weekDay.title)
                    .font(.system(size: 16))
                if !isSelected {
                    Text(.editWeekViewMealsCounter(mealsCount))
                        .font(.system(size: 12, weight: .light))
                }
            }
            if isToday {
                ZStack {
                    Rectangle()
                        .fill(AppColors.primaryGreen.opacity(0.6))
                        .frame(width: 60, height: 24)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text(.todayTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColors.primaryGreen)
                }
            }
            Spacer()
            if isSelected {
                Image(systemName: "chevron.down")
                    .foregroundStyle(AppColors.primaryText)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.primaryText)
            }
        }
        .padding(.vertical)
    }
}

struct MealsCardView: View {

    let meals: [Meal]
    let mealTapped: (Meal) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(MealType.completeMealsOrdered) { mealType in
                if let meal = meals.first(where: { $0.type == mealType }) {
                    Button {
                        mealTapped(meal)
                    } label: {
                        EditWeekMealCardView(meal: meal)
                    }
                    .accessibilityLabel(Text("\(meal.type.title), \(String(localized: .accessibilityEditWeekViewOpenMealDetail))"))
                    .buttonStyle(.plain)
                } else {
                    Text(.somethingWentWrong)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(AppColors.primaryText)
                }
            }
        }
    }
}

private struct EditWeekMealCardView: View {
    let meal: Meal
    var body: some View {
        HStack {
            Rectangle()
                .fill(meal.type.color)
                .frame(width: 4)
            HStack {
                ZStack {
                    Circle()
                        .fill(meal.type.color.opacity(0.18))
                        .frame(width: 30, height: 30)
                    Image(systemName: meal.type.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(meal.type.color)
                }
                VStack(alignment: .leading) {
                    Text(meal.type.title)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.primaryText)
                    if meal.items.isEmpty {
                        Text(.mealCardAddFoods)
                            .font(.system(size: 12))
                            .foregroundStyle(AppColors.secondaryText.opacity(0.6))
                    } else {
                        Text(
                            meal.items.map(\.name).joined(separator: " · ")
                        )
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.secondaryText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.primaryText)
            }
            .padding(.vertical)
            .padding(.trailing)
        }
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}

#Preview {
    EditWeekView(
        viewModel: EditWeekViewModel(
            service: MockMealDataService(),
            dateProvider: DebugDateProvider()
        )
    )
}
