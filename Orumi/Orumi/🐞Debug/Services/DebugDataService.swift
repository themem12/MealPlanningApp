//
//  DebugDataService.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 06/07/26.
//

import Foundation

class DebugDataService {
    let mealService: MealDataServiceProtocol

    init(mealService: MealDataServiceProtocol) {
        self.mealService = mealService
    }

    func load(_ preset: DebugPreset) {
        switch preset {
        case .firstLaunch:
            loadFirstLaunch()
        case .perfectWeek:
            loadPerfectWeek()
        case .fillWeekPlans:
            loadWeekPlans()
        }
    }

    private func loadFirstLaunch() {
        
    }

    private func loadPerfectWeek() {
        
    }

    private func loadWeekPlans() {

        // First we clean the dataBase before adding anything else
        mealService.deleteAllData()

        for day in WeekDay.allCases {
            print("Creating \(day)")
            let dayPlan = mealService.getOrCreatePlan(for: day)
            print("Got plan \(dayPlan.day)")
            for meal in dayPlan.meals {
                print("Meal: \(meal.type)")
                switch meal.type {
                case .breakfast:
                    for item in Meal.breakfast.items {
                        mealService.addFoodItem(to: meal, foodItem: item)
                    }
                case .lunch:
                    for item in Meal.lunch.items {
                        mealService.addFoodItem(to: meal, foodItem: item)
                    }
                case .dinner:
                    for item in Meal.dinner.items {
                        mealService.addFoodItem(to: meal, foodItem: item)
                    }
                case .collationAM:
                    for item in Meal.morningSnack.items {
                        mealService.addFoodItem(to: meal, foodItem: item)
                    }
                case .collationPM:
                    for item in Meal.afternoonSnack.items {
                        mealService.addFoodItem(to: meal, foodItem: item)
                    }
                }
            }
        }

        NotificationCenter.default.post(
            name: .mealDataDidChange,
            object: nil
        )
    }
}
