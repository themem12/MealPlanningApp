//
//  TodayResumeView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 21/05/26.
//

import SwiftUI

struct TodayResumeView: View {

    @State var viewModel: TodayResumeViewModel

    init(viewModel: TodayResumeViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 76))
                .foregroundStyle(AppColors.dinner.opacity(0.9))
                .padding(.bottom, 10)
            Text("Day completed")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
                .padding(.bottom, 8)
            if viewModel.isEmptyDay {
                Spacer()
                EmptyRecordDayView()
                Spacer()
            } else {
                DayDataView(viewModel: viewModel)
            }
        }
        .padding()
        .background(AppColors.background)
    }
}

struct EmptyRecordDayView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "calendar")
                    .font(.system(size: 170))
                    .foregroundStyle(AppColors.primaryGreen)
                Image(systemName: "circle.slash")
                    .font(.system(size: 70))
                    .foregroundStyle(AppColors.primaryGreen)
                    .background(AppColors.background)
                    .clipShape(Circle())
                Image(systemName: "fork.knife")
                    .font(.system(size: 40))
                    .foregroundStyle(AppColors.primaryGreen)
                    .padding(.trailing, 23)
                    .padding(.bottom, 17)
            }
            Text("No meals were planned today.")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)
            Text("There's nothing to review for this day")
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(AppColors.primaryText)
        }.frame(maxWidth: .infinity)
    }
}

private struct DayDataView: View {
    let viewModel: TodayResumeViewModel
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(
                        AppColors.border,
                        lineWidth: 12
                    )
                Circle()
                    .trim(from: 0, to: viewModel.progressBarValue)
                    .stroke(
                        AppColors.primaryGreen,
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("\(viewModel.mealsCompleted)/\(viewModel.totalMeals)")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(AppColors.primaryText)
                    Text("meals")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.primaryText)
                    Text(viewModel.percentage)
                        .foregroundStyle(AppColors.primaryGreen)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .frame(width: 160)
            .animation(
                .spring(duration: 1),
                value: 0.6
            )
            HStack {
                Text("Consistency matters.")
                    .foregroundStyle(AppColors.secondaryText)
                Image(systemName: "heart")
                    .foregroundStyle(.yellow)
            }
            .font(.system(size: 14, weight: .light))
            .padding(.top, 12)
            HStack {
                ForEach(MealType.completeMealsOrdered) { mealType in
                    if let meal = viewModel.meals.first(
                        where: { $0.mealType == mealType }
                    ) {
                        MealResumeCard(
                            meal: meal
                        )
                        .padding(.vertical, 8)
                    }
                }
            }
            VStack(spacing: 8) {
                Image(systemName: "flame")
                    .foregroundStyle(.red)
                    .font(.system(size: 14))
                    .padding(.top, 12)
                Text(viewModel.calories)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
                Text("cal")
                    .font(.system(size: 14))
                    .padding(.bottom, 12)
                    .foregroundStyle(AppColors.secondaryText)
            }.padding(.horizontal, 32)
                .appSoftCardStyle(background: AppColors.softSage)
            Label("You fueled your body well today", systemImage: "leaf")
                .foregroundStyle(AppColors.deepGreen)
                .font(.system(size: 14))
                .padding(.top, 12)
            Spacer()
        }.frame(maxWidth: .infinity)
    }
}

private struct MealResumeCard: View {
    let meal: TodayReviewMealModel
    var body: some View {
        VStack(spacing: 12) {
            Group {
                if meal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 20, height: 20)
            .padding(.top, 16)
            Image(systemName: meal.mealType.icon)
                .foregroundStyle(meal.mealType.color)
                .frame(width: 24, height: 24)
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .appSoftCardStyle(background: meal.mealType.color.opacity(0.08))
    }
}

#Preview {
    TodayResumeView(
        viewModel:
            TodayResumeViewModel(
                dayRecord: DayRecord(
                    date: .now,
                    from: DayPlan(day: .monday),
                    isCompleted: true
                )
            )
    )
}
