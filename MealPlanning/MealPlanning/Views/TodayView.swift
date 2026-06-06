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
                    if !viewModel.sortedMeals.isEmpty {
                        VStack(alignment: .leading) {
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
                            ScrollView {
                                ForEach(viewModel.sortedMeals) { meal in
                                    Button {
                                        selectedMeal = meal
                                    } label: {
                                        MealCard(meal: meal)
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
                                    Text("End Day")
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
                            "You don't have a plan for today yet, don't go crazy",
                            systemImage: "fork.knife"
                        )
                    }
                }
            }
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EditWeekView(
                            viewModel: viewModel.getEditWeekViewModel()
                        )
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .task {
                viewModel.loadTodayPlan()
            }
            .navigationDestination(item: $selectedMeal) { meal in
                MealDetailView(
                    viewModel: viewModel.makeMealDetailViewModel(for: meal)
                )
            }
            .alert(
                viewModel.alertMessage,
                isPresented: $viewModel.showAlert) {
                    Button(role: .confirm) {
                        viewModel.confirmEndDay()
                    }
                    Button(role: .cancel, action: {})
                }
        }
    }
}

struct MealCard: View {
    private let hasItems: Bool
    let meal: Meal

    init(meal: Meal) {
        self.hasItems = !meal.items.isEmpty
        self.meal = meal
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
                    .font(.system(size: 26, weight: .semibold))
            }.padding(.top)
            VStack(alignment: .leading) {
                Text(meal.type.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                if !hasItems {
                    Text("Add foods")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.secondaryText.opacity(0.7))
                } else {
                    ForEach(meal.items) { item in
                        HStack {
                            Text("•")
                                .foregroundStyle(meal.type.color)
                            Text(item.name)
                                .font(.system(size: 14, weight: .light))
                                .foregroundStyle(AppColors.secondaryText)
                        }
                    }
                }
            }
            .padding()
            Spacer()
            Button {
                if hasItems {
                    meal.isCompleted.toggle()
                }
            } label: {
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
            .buttonStyle(.plain)
            .padding(.top)
        }
        .padding(.trailing)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .appCardStyle()
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    TodayView(viewModel: TodayViewModel(
        service: MockMealDataService(),
        dateProvider: MockDateProvider(today: .now)
    ))
}
