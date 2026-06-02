//
//  MealDataService.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 06/05/26.
//

import SwiftData
import Foundation

protocol MealDataServiceProtocol {

    func getOrCreatePlan(
        for day: WeekDay
    ) -> DayPlan

    func addFoodItem(
        to meal: Meal,
        foodItem: FoodItem
    )

    func completeMeal(
        _ meal: Meal
    )

    func endDay(
        for dayPlan: DayPlan
    )

    func dayEnded(
        for date: Date
    ) -> Bool

    func getTodayRecord() -> DayRecord?
}

final class LiveMealDataService: MealDataServiceProtocol {

    private let context: ModelContext
    private let dateProvider: DateProvider

    init(
        context: ModelContext,
        dateProvider: DateProvider = LiveDateProvider()
    ) {
        self.context = context
        self.dateProvider = dateProvider
    }

    func getOrCreatePlan(for day: WeekDay) -> DayPlan {
        let descriptor = FetchDescriptor<DayPlan>()

        let fetchedPlans = (try? context.fetch(descriptor)) ?? []
        
        if let existingPlan = fetchedPlans.first(where: {
            $0.day == day
        }) {
            return existingPlan
        }
        
        let newPlan = DayPlan(
            day: day,
            meals: createDefaultMeals()
        )
        
        context.insert(newPlan)

        // TODO: catch the error
        try? context.save()
        
        return newPlan
    }
    
    func addFoodItem(to meal: Meal, foodItem: FoodItem) {
        
        context.insert(foodItem)
        
        meal.items.append(foodItem)
        
        // TODO: catch the error
        try? context.save()
    }

    func completeMeal(_ meal: Meal) {
        meal.isCompleted.toggle()

        try? context.save()
    }

    func endDay(for dayPlan: DayPlan) {
        let today = dateProvider.today

        guard !dayEnded(for: today) else {
            // Day already end
            return
        }
        let dayRecord = DayRecord(date: today, from: dayPlan, isCompleted: true)
        context.insert(dayRecord)
        try? context.save()
        dayPlan.meals = dayPlan.meals.map({ meal in
            meal.isCompleted = false
            return meal
        })
        try? context.save()
    }

    func dayEnded(for date: Date) -> Bool {
        let descriptor = FetchDescriptor<DayRecord>(
            predicate: #Predicate {
                $0.date == date
            }
        )
        
        let existing = try? context.fetch(descriptor)
        
        return !(existing?.isEmpty ?? true)
    }

    func getTodayRecord() -> DayRecord? {
        let today = dateProvider.today
        let descriptor = FetchDescriptor<DayRecord>(
            predicate: #Predicate {
                $0.date == today
            }
        )
        
        let existing = try? context.fetch(descriptor)
        return existing?.first
    }

    private func createDefaultMeals() -> [Meal] {
        [
            Meal(type: .breakfast),
            Meal(type: .collationAM),
            Meal(type: .lunch),
            Meal(type: .collationPM),
            Meal(type: .dinner),
        ]
    }
}
