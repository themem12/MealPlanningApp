//
//  ProgressCircleView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 16/06/26.
//

import SwiftUI

struct ProgressCircleView: View {

    var progressBarValue: CGFloat
    let mealsCompleted: Int
    let totalMeals: Int
    let size: CGFloat
    let progressBarColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AppColors.border,
                    lineWidth: 12
                )
            Circle()
                .trim(from: 0, to: progressBarValue)
                .stroke(
                    progressBarColor,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            VStack {
                Text(.mealsFraction(mealsCompleted, totalMeals))
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(AppColors.primaryText)
                Text(.progressCircleViewTitle)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: size)
    }
}

#Preview {
    ProgressCircleView(
        progressBarValue: 1,
        mealsCompleted: 2,
        totalMeals: 3,
        size: 160,
        progressBarColor: AppColors.primaryGreen
    )
}
