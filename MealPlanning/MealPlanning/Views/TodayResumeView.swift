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
        GeometryReader { geometry in
            let layoutMode = geometry.size.width.layoutMode
            VStack(spacing: 12) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 76))
                    .foregroundStyle(AppColors.dinner.opacity(0.9))
                    .padding(.bottom, 10)
                Text(.todayResumeViewTitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                Text(viewModel.dateString)
                    .font(
                        .system(
                            size: layoutMode == .compact ? 16 : 24,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(AppColors.secondaryText)
                    .padding(.bottom, 8)
                if viewModel.isEmptyDay {
                    Spacer()
                    EmptyRecordDayView()
                    Spacer()
                } else {
                    DayDataView(
                        viewModel: viewModel,
                        layoutMode: geometry.size.width.layoutMode
                    )
                }
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
            Text(.todayResumeViewEmptyTitle)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.primaryText)
            Text(.todayResumeViewEmptyMessage)
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(AppColors.primaryText)
        }.frame(maxWidth: .infinity)
    }
}

private struct DayDataView: View {
    let viewModel: TodayResumeViewModel
    let layoutMode: LayoutMode

    @State private var animatedProgress: Double = 0
    @State private var animatedCompletedMeals = 0
    @State private var mealTypeHighlighted: MealType?
    @State private var animatedColor: Color = AppColors.border

    var body: some View {
        VStack {
            ProgressCircleView(
                progressBarValue: animatedProgress,
                mealsCompleted: animatedCompletedMeals,
                totalMeals: viewModel.totalMeals,
                size: layoutMode == .compact ? 160 : 200,
                progressBarColor: animatedColor
            )
            HStack {
                Text(.todayResumeViewComment)
                    .foregroundStyle(AppColors.secondaryText)
                Image(systemName: "heart")
                    .foregroundStyle(.yellow)
            }
            .font(.system(size: 14, weight: .light))
            .padding(.top, 12)
            Label(.todayResumeViewSummaryTitle, systemImage: "leaf")
                .foregroundStyle(AppColors.deepGreen)
                .font(.system(size: 14))
                .padding(.top, 8)
            HStack {
                ForEach(MealType.completeMealsOrdered) { mealType in
                    if let meal = viewModel.meals.first(
                        where: { $0.mealType == mealType }
                    ) {
                        MealResumeCard(
                            meal: meal,
                            canHighlight: mealType == mealTypeHighlighted,
                            isWideLayout: layoutMode == .wide
                        )
                        .padding(.vertical, 8)
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 3)
            ) {
                animatedProgress = viewModel.progressBarValue
                for index in 1...viewModel.totalMeals {
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + Double(index) * 0.4
                    ) {
                        animatedCompletedMeals = viewModel.meals[index - 1].isCompleted ? animatedCompletedMeals + 1 : animatedCompletedMeals
                        if animatedCompletedMeals >= viewModel.totalMeals - 1 {
                            animatedColor = AppColors.goodDay
                        } else if animatedCompletedMeals >= 1 {
                            animatedColor = AppColors.regularDay
                        } else {
                            animatedColor = AppColors.border
                        }
                        mealTypeHighlighted = MealType.completeMealsOrdered[index - 1]
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 0.25
                        ) {
                            mealTypeHighlighted = nil
                        }
                    }
                }
            }
        }
        .onDisappear {
            animatedProgress = 0
            animatedCompletedMeals = 0
        }
    }
}

private struct MealResumeCard: View {
    let meal: TodayReviewMealModel
    let canHighlight: Bool
    var shouldHighlight: Bool { canHighlight && meal.isCompleted }
    let isWideLayout: Bool
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
            .iconSize(isWideLayout ? .medium : .xSmall)
            .padding(.top, 16)
            Image(systemName: meal.mealType.icon)
                .iconSize(isWideLayout ? .medium : .xSmall)
                .foregroundStyle(meal.mealType.color)
                .padding(.bottom, isWideLayout ? 8 : 16)
            if isWideLayout {
                Text(meal.mealType.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                    .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .appSoftCardStyle(background: meal.mealType.color.opacity(0.08))
        .scaleEffect(
            shouldHighlight
            ? 1.2
            : 1.0
        )
        .shadow(
            color: .black.opacity(
                shouldHighlight ? 0.3 : 0
            ),
            radius: 12
        )
        .animation(
            .spring(
                response: 0.25,
                dampingFraction: 0.6
            ),
            value: shouldHighlight
        )
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
