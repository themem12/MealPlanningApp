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

        var currentDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: lastRecord.date
        )!
        
        while currentDate < calendar.startOfDay(for: dateProvider.today) {
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
            return
        }

        let dayPlan = mealService.getOrCreatePlan(for: weekDay)

        mealService.endDay(for: dayPlan, date: date)
    }
}
