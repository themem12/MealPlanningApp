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
