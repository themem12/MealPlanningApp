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
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        HistoryView(
                            viewModel: viewModel.getHistoryViewModel()
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

#Preview {
    TodayView(viewModel: TodayViewModel(
        service: MockMealDataService(),
        dateProvider: MockDateProvider(today: .now)
    ))
}
