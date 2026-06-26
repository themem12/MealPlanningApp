//
//  TodayView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import SwiftUI
import SwiftData

struct TodayView: View {

    @State private var viewModel: TodayViewModel
    @State private var selectedMeal: Meal?

    init(viewModel: TodayViewModel) {
        _viewModel = State(
            initialValue: viewModel
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if let dayRecord = viewModel.dayRecord {
                    TodayResumeView(
                        viewModel: viewModel.makeResumeViewModel(with: dayRecord)
                    )
                } else {
                    GeometryReader { geometry in
                        let layoutMode = geometry.size.width.layoutMode
                        VStack(alignment: .leading) {
                            HeaderView(viewModel: viewModel)
                            HStack {
                                if layoutMode == .wide {
                                    ScrollView {
                                        TodaySidebarView(meals: viewModel.sortedMeals)
                                            .frame(width: 380)
                                    }.scrollBounceBehavior(.basedOnSize)
                                }
                                TodayContentView(viewModel: viewModel, mealSelected: { meal in
                                    selectedMeal = meal
                                })
                            }
                        }
                        .sheet(isPresented: $viewModel.addFoodTapped) {
                            FoodItemView(viewModel: viewModel.getFoodItemViewModel()
                            )
                        }
                    }
                }
            }
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EditWeekContainerView(
                            viewModel: viewModel.getEditWeekContainerViewModel()
                        )
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        HistoryContainerView(
                            viewModel: viewModel.getHistoryContainerViewModel()
                        )
                    } label: {
                        Image(systemName: "calendar.badge.checkmark")
                    }
                }
            }
            .task {
                viewModel.loadTodayPlan()
            }
            .navigationDestination(item: $selectedMeal) { meal in
                MealDetailView(
                    viewModel: viewModel.makeMealDetailViewModel(for: meal)
                ) { foodItem in
                    viewModel.foodItemTapped(foodItem: foodItem, meal: meal)
                }
            }
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showAlert
            ) {
                Button(.finishDay) {
                    viewModel.confirmEndDay()
                }
                Button(role: .cancel, action: {})
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

private struct HeaderView: View {

    let viewModel: TodayViewModel

    var body: some View {
        Group {
            HStack(spacing: 8) {
                Text(viewModel.title)
                    .font(.title2.bold())
                    .foregroundStyle(AppColors.secondaryText)
                Image(systemName: viewModel.titleIcon)
                    .font(.title3)
                    .foregroundStyle(viewModel.titleIconColor)
            }
            Text(viewModel.dateTitle)
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(AppColors.primaryText)
        }.padding(.horizontal)
    }
}

private struct TodayContentView: View {

    let viewModel: TodayViewModel
    let mealSelected: (Meal) -> ()

    var body: some View {
        Group {
            if !viewModel.sortedMeals.isEmpty {
                VStack(alignment: .leading) {
                    ScrollView {
                        ForEach(viewModel.sortedMeals) { meal in
                            Button {
                                mealSelected(meal)
                            } label: {
                                MealCard(meal: meal) {
                                    viewModel.completeMeal(meal)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.top)
                            .padding(.horizontal)
                        }
                    }
                    Button {
                        viewModel.endDayTapped()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "flag.pattern.checkered")
                            Text(.finishDay)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(AppColors.deepGreen)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            } else {
                ContentUnavailableView(
                    String(localized: .todayViewEmptyPlanTitle),
                    systemImage: "fork.knife"
                )
            }
        }
    }
}

private struct TodaySidebarView: View {
    let meals: [Meal]
    var completedMeals: Int {
        meals.filter({ $0.isCompleted }).count
    }
    var totalMeals: Int {
        meals.count
    }

    @State private var animatedProgress: Double = 0
    @State private var animatedColor: Color = AppColors.border

    var body: some View {
        VStack(alignment: .leading) {
            Text(.todayTitle)
                .font(.system(size: 30, weight: .bold))
            Text(.todayViewSidebarSubtitle)
                .font(.system(size: 20, weight: .regular))

            Spacer()
            HStack {
                Spacer()
                ProgressCircleView(
                    progressBarValue: animatedProgress,
                    mealsCompleted: completedMeals,
                    totalMeals: totalMeals,
                    size: 180,
                    progressBarColor: animatedColor
                )
                Spacer()
            }
            .padding(.bottom, 8)

            Divider()
                .overlay(.gray.opacity(0.3))

            Text(.todayViewSidebarMealsTitle)
                .font(.system(size: 14, weight: .bold))
                .padding(.top)

            ForEach(MealType.completeMealsOrdered) { mealType in
                if let meal = meals.filter({ $0.type == mealType }).first {
                    HStack {
                        MealIconView(
                            mealType: meal.type,
                            size: 45
                        )
                        Text(mealType.title)
                        Spacer()
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
            }
        }
        .padding()
        .appSoftCardStyle(background: AppColors.panel)
        .padding()
        .onChange(of: completedMeals) { oldValue, newValue in
            withAnimation(
                .easeInOut(duration: 1)
            ){
                if newValue >= totalMeals - 1 {
                    animatedColor = AppColors.goodDay
                } else if newValue >= 1 {
                    animatedColor = AppColors.regularDay
                } else {
                    animatedColor = AppColors.border
                }
                animatedProgress = Double(newValue) / Double(totalMeals)
            }
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1)
            ){
                if completedMeals >= totalMeals - 1 {
                    animatedColor = AppColors.goodDay
                } else if completedMeals >= 1 {
                    animatedColor = AppColors.regularDay
                } else {
                    animatedColor = AppColors.border
                }
                animatedProgress = Double(completedMeals) / Double(totalMeals)
            }
        }
    }
}

#Preview {
    TodayView(viewModel: TodayViewModel(
        service: MockMealDataService(),
        dateProvider: MockDateProvider(today: .now)
    ))
}
