//
//  MockMealDataService.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 06/05/26.
//

import Foundation

final class MockMealDataService: MealDataServiceProtocol {

    func getOrCreatePlan(for day: WeekDay) -> DayPlan {
        DayPlan(day: .monday, meals: [
            Meal(type: .breakfast),
            Meal(type: .collationAM),
            Meal(type: .lunch),
            Meal(type: .collationPM),
            Meal(type: .dinner),
        ])
    }
    
    func addFoodItem(to meal: Meal, foodItem: FoodItem) { }

    func editFoodItem(_ foodItem: FoodItem) { }

    func deleteFoodItem(_ foodItem: FoodItem, from meal: Meal) { }

    func completeMeal(_ meal: Meal) { }

    func endDay(for dayPlan: DayPlan) { }
    
    func dayEnded(for date: Date) -> Bool {
        return true
    }

    func getTodayRecord() -> DayRecord? {
        return nil
    }

    func getMonthRecord(month: Date) -> [DayRecord] {
        return []
    }
}
