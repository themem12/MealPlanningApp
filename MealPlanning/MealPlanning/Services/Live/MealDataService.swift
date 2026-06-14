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

    func editFoodItem(
        _ foodItem: FoodItem
    )

    func deleteFoodItem(
        _ foodItem: FoodItem,
        from meal: Meal
    )

    func completeMeal(
        _ meal: Meal
    )

    func endDay(
        for dayPlan: DayPlan,
        date: Date
    )

    func endToday(
        with dayPlan: DayPlan
    )

    func dayEnded(
        for date: Date
    ) -> Bool

    func getTodayRecord() -> DayRecord?

    func getMonthRecord(month: Date) -> [DayRecord]

    func getLastRecord() -> DayRecord?
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

    func editFoodItem(_ foodItem: FoodItem) {
        try? context.save()
    }

    func deleteFoodItem(_ foodItem: FoodItem, from meal: Meal) {
        meal.items.removeAll { $0.id == foodItem.id }
        context.delete(foodItem)
        try? context.save()
    }

    func completeMeal(_ meal: Meal) {
        meal.isCompleted.toggle()

        try? context.save()
    }

    func endToday(with dayPlan: DayPlan) {
        endDay(for: dayPlan, date: dateProvider.today)
    }

    func endDay(for dayPlan: DayPlan, date: Date) {
        guard !dayEnded(for: date) else {
            // Day already end
            return
        }
        print("before record: ", dayPlan.meals.filter(\.isCompleted).count)
        let dayRecord = DayRecord(date: date, from: dayPlan, isCompleted: true)
        print("after record: ", dayRecord.meals.filter(\.isCompleted).count)
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

    func getMonthRecord(month: Date) -> [DayRecord] {
        let calendar = Calendar.current

        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else { return [] }

        guard let endOfMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: 0),
            to: startOfMonth
        ) else { return [] }
        
        let descriptor = FetchDescriptor<DayRecord>(
            predicate: #Predicate {
                $0.date >= startOfMonth &&
                $0.date < endOfMonth
            }
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    func getLastRecord() -> DayRecord? {
        var descriptor = FetchDescriptor<DayRecord>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )
        
        descriptor.fetchLimit = 1
        
        return try? context.fetch(descriptor).first
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
