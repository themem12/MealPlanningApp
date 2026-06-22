//
//  DayRecordViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 11/06/26.
//

import Observation
import SwiftUI

final class DayRecordViewModel {
    private(set) var dayTitle: String = ""
    private(set) var dateTitle: String = ""
    private(set) var isEmpty: Bool = true
    private(set) var dayStateTitle: String = ""
    private(set) var dayStateColor: Color = .clear
    private(set) var completedDaysTitle: String = ""
    private(set) var meals: [Meal] = []

    init(dayRecord: DayRecord) {
        setActualMeals(mealRecords: dayRecord.meals)
        dayTitle = WeekDay(
            rawValue: Calendar.current.component(.weekday, from: dayRecord.date)
        )?.title ?? ""
        dateTitle = dayRecord.date.formatted(.dateTime.month().day().year()).uppercased()
        let mealsCounts = getMealsCounts(meals: meals)
        self.isEmpty = mealsCounts.totalMeals == 0
        setDayState(completedMeals: mealsCounts.completedMeals, totalMeals: mealsCounts.totalMeals)
        completedDaysTitle = "\(mealsCounts.completedMeals) of \(mealsCounts.totalMeals) meals completed"
    }

    private func setActualMeals(mealRecords: [MealRecord]) {
        let notEmptyMeals = mealRecords.filter({ $0.items.count > 0 })
        let actualMeals = notEmptyMeals.map({ Meal(mealRecord: $0) })
        for mealType in MealType.completeMealsOrdered {
            if let meal = actualMeals.first(where: { $0.type == mealType}) {
                meals.append(meal)
            }
        }
    }

    private func getMealsCounts(
        meals: [Meal]
    ) -> (totalMeals: Int, completedMeals: Int) {
        let actualMeals = meals.filter({ $0.items.count > 0 })
        return (actualMeals.count, actualMeals.filter({ $0.isCompleted }).count)
    }

    private func setDayState(completedMeals: Int, totalMeals: Int) {
        guard !isEmpty else {
            dayStateColor = AppColors.deepGreen
            dayStateTitle = "Day Completed"
            return
        }
        if completedMeals >= totalMeals - 1 {
            dayStateColor = .green
            dayStateTitle = "Good Day"
        } else if completedMeals >= totalMeals / 2 {
            dayStateColor = .yellow
            dayStateTitle = "Regular Day"
        } else {
            dayStateColor = .red
            dayStateTitle = "Missed Day"
        }
    }
}
