//
//  EditWeekWideView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 22/06/26.
//

import SwiftUI

struct EditWeekWideView: View {

    @State private var editWeekViewModel: EditWeekWideViewModel
    @State private var selectedMeal: Meal?

    init(editWeekViewModel: EditWeekWideViewModel) {
        _editWeekViewModel = State(
            initialValue: editWeekViewModel
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Header
            Text("Edit Week")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
            Text("Review and edit your meals for the week.")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppColors.primaryText)

            // Content View
            HStack(spacing: 8) {
                // Week list view
                WeekListView(viewModel: editWeekViewModel) { weekDay in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        editWeekViewModel.selectedDay = weekDay
                        selectedMeal = nil
                    }
                }

                // Meals list view
                Group {
                    MealsCardView(
                        meals: editWeekViewModel.getMealsFromSelectedDay()) { meal in
                            withAnimation(.easeInOut(duration: 0.4)) {
                                selectedMeal = meal
                            }
                        }
                }
                .padding()
                .appSoftCardStyle(background: AppColors.background)
                .frame(width: 300)

                // Meal Detail view
                if let selectedMeal {
                    MealDetailView(
                        viewModel: editWeekViewModel.makeMealDetailViewModel(for: selectedMeal)
                    ) { foodItem in
                        editWeekViewModel
                            .foodItemTapped(
                                foodItem: foodItem,
                                meal: selectedMeal
                            )
                    }
                    .appSoftCardStyle(background: AppColors.background)
                    .id(selectedMeal.id)
                    .transition(.opacity)
                } else {
                    UnselectedMealView()
                        .appSoftCardStyle(background: AppColors.background)
                }
            }
        }
        .padding()
        .background(AppColors.background)
        .sheet(isPresented: $editWeekViewModel.addFoodTapped) {
            FoodItemView(viewModel: editWeekViewModel.getFoodItemViewModel()
            )
        }
    }
}

private struct WeekListView: View {

    let viewModel: EditWeekViewModel
    let weekDayTapped: (WeekDay) -> Void

    var body: some View {
        VStack {
            ForEach(WeekDay.orderedCases) { weekDay in
                Button {
                    weekDayTapped(weekDay)
                } label: {
                    HeaderCardView(
                        mealsCount: viewModel.getMealsCountFor(weekDay: weekDay),
                        weekDay: weekDay,
                        isSelected: false,
                        isToday: viewModel.isCurrentDay(weekDay)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .appSoftCardStyle(background: weekDay == viewModel.selectedDay ? AppColors.primaryGreen.opacity(0.3) : AppColors.card)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(width: 300)
    }
}

private struct UnselectedMealView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .font(.system(size: 170))
                .foregroundStyle(AppColors.primaryGreen)
            Text("You haven't selected any meal yet")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
            Text("Tap any meal to see in detail")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding()
        .frame(
            maxWidth: .infinity, maxHeight: .infinity
        )
    }
}

#Preview {
    EditWeekWideView(
        editWeekViewModel:
            EditWeekWideViewModel(
                service: MockMealDataService(),
                dateProvider: MockDateProvider(today: .now)
            )
    )
}
