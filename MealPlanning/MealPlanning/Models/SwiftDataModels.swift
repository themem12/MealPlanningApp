//
//  SwiftDataModels.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import SwiftUI
import SwiftData

@Model
class DayPlan {
    var id: UUID = UUID()
    var day: WeekDay
    @Relationship(deleteRule: .cascade)
    var meals: [Meal]

    init(day: WeekDay, meals: [Meal] = []) {
        self.day = day
        self.meals = meals
    }
}

@Model
class Meal {
    var id: UUID = UUID()
    var type: MealType
    @Relationship(deleteRule: .cascade)
    var items: [FoodItem]
    var isCompleted: Bool

    init(type: MealType, items: [FoodItem] = []) {
        self.type = type
        self.items = items
        self.isCompleted = false
    }

    init(mealRecord: MealRecord) {
        self.type = mealRecord.type
        self.items = mealRecord.items.map({ FoodItem(foodItemRecord: $0) })
        self.isCompleted = mealRecord.isCompleted
    }
}

@Model
class FoodItem {
    var id: UUID = UUID()
    var name: String
    var portion: String
    var calories: Int

    init(name: String, portion: String, calories: Int) {
        self.name = name
        self.portion = portion
        self.calories = calories
    }

    init(foodItemRecord: FoodItemRecord) {
        self.name = foodItemRecord.name
        self.portion = foodItemRecord.portion
        self.calories = foodItemRecord.calories
    }
}

@Model
class DayRecord {
    var id: UUID = UUID()
    var date: Date
    @Relationship(deleteRule: .cascade)
    var meals: [MealRecord]
    var isCompleted: Bool

    init(date: Date, from dayPlan: DayPlan, isCompleted: Bool) {
        self.date = date
        self.meals = dayPlan.meals.map({ MealRecord(from: $0) })
        self.isCompleted = isCompleted
    }

    // This init is for an empty day record and will be used in History for the days that doesn't have a record
    init(date: Date) {
        self.date = date
        self.meals = []
        self.isCompleted = true
    }
}

@Model
class MealRecord {
    var id: UUID = UUID()
    var type: MealType
    @Relationship(deleteRule: .cascade)
    var items: [FoodItemRecord]
    var isCompleted: Bool

    init(type: MealType, items: [FoodItemRecord] = [], isCompleted: Bool) {
        self.type = type
        self.items = items
        self.isCompleted = isCompleted
    }

    init(from meal: Meal) {
        self.type = meal.type
        self.items = meal.items.map({ FoodItemRecord(from: $0) })
        self.isCompleted = meal.isCompleted
    }
}

@Model
class FoodItemRecord {
    var id: UUID = UUID()
    var name: String
    var portion: String
    var calories: Int

    init(name: String, portion: String, calories: Int) {
        self.name = name
        self.portion = portion
        self.calories = calories
    }

    init(from item: FoodItem) {
        self.name = item.name
        self.portion = item.portion
        self.calories = item.calories
    }
}
