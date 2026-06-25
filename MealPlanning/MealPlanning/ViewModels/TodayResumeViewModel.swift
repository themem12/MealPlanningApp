//
//  TodayResumeViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 24/05/26.
//

import Foundation
import Observation

@Observable
final class TodayResumeViewModel {
    var mealsCompleted: Int = 0
    var totalMeals: Int = 0
    var meals: [TodayReviewMealModel] = []
    var percentage: String = ""
    var progressBarValue: Double = 0
    var calories: String = ""
    var isEmptyDay: Bool = false
    var dateString: String = ""

    init(dayRecord: DayRecord) {
        let actualMeals = dayRecord.meals.filter({ !$0.items.isEmpty })
        totalMeals = actualMeals.count
        mealsCompleted = actualMeals.filter(\.isCompleted).count
        meals = actualMeals.map {
            TodayReviewMealModel(
                mealType: $0.type,
                isCompleted: $0.isCompleted
            )
        }
        guard totalMeals > 0 else {
            isEmptyDay = true
            percentage = ""
            progressBarValue = 1
            return
        }
        let completion = Double(mealsCompleted) / Double(totalMeals)
        percentage = "\(Int(completion * 100))%"
        progressBarValue = completion

        getCaloriesTotal(from: actualMeals)

        dateString = dayRecord.date.formatted(
            .dateTime
                .weekday(.wide)
                .month(.wide)
                .day()
        )
    }

    private func getCaloriesTotal(from meals: [MealRecord]) {
        var caloriesCount: Int = 0
        for meal in meals {
            if meal.isCompleted {
                for item in meal.items {
                    caloriesCount += item.calories
                }
            }
        }
        calories = "\(caloriesCount)"
    }
}
