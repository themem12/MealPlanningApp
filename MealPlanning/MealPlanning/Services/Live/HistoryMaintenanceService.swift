//
//  HistoryMaintenanceService.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 13/06/26.
//

import Foundation

protocol HistoryMaintenanceServiceProtocol {
    func processPendingDays()
}

final class LiveHistoryMaintenanceService: HistoryMaintenanceServiceProtocol {
    private let mealService: MealDataServiceProtocol
    private let dateProvider: DateProvider

    init(mealService: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.mealService = mealService
        self.dateProvider = dateProvider
    }

    func processPendingDays() {
        print("Process pending days")
        print("Today: ", dateProvider.today)
        let calendar = Calendar.current
        guard let lastRecord = mealService.getLastRecord() else {
            // This can mean the is the first time the user enters the app or he never end a day manually, for both cases we should create an empty record for the day before
            if let previousDay = calendar.date(
                byAdding: .day, value: -1, to: dateProvider.today
            ) {
                createRecord(for: previousDay)
            }
            return
        }

        print("Last record: ", lastRecord.date)

        var currentDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: lastRecord.date
        )!
        
        while currentDate < calendar.startOfDay(for: dateProvider.today) {
            print("Creating record for:", currentDate)
            createRecord(for: currentDate)

            currentDate = calendar.date(
                byAdding: .day,
                value: 1,
                to: currentDate
            )!
        }
    }

    private func createRecord(for date: Date) {
        guard let weekDay = WeekDay(
            rawValue: Calendar.current.component(.weekday, from: date)
        ) else {
            print("Error while getting weekDay")
            return
        }
        let dayPlan = mealService.getOrCreatePlan(for: weekDay)

        for meal in dayPlan.meals {
            print(
                meal.type,
                meal.isCompleted
            )
        }

        mealService.endDay(for: dayPlan, date: date)
    }
}
