//
//  TodayViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 08/05/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class TodayViewModel {
    private(set) var service: MealDataServiceProtocol
    private let dateProvider: DateProvider
    private var currentDayPlan: DayPlan?
    
    var title = "Good day"
    var titleIcon = ""
    var titleIconColor: Color = .clear
    var dateTitle = "Today"
    var dayRecord: DayRecord?
    var alertMessage: String = ""
    var showAlert: Bool = false

    var sortedMeals: [Meal] {
        currentDayPlan?.meals.sorted {
            $0.type.order < $1.type.order
        } ?? []
    }

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        dayRecord = service.getTodayRecord()
        self.dateProvider = dateProvider
    }

    func loadTodayPlan() {
        currentDayPlan = service.getOrCreatePlan(for: dateProvider.weekDay)
        currentDayPlan?.meals = currentDayPlan?.meals.sorted(by: { $0.type.order < $1.type.order }) ?? []
        setDateTitle()
        setViewTitle()
    }

    func makeMealDetailViewModel(for meal: Meal) -> MealDetailViewModel {
        return MealDetailViewModel(
            service: service,
            meal: meal
        )
    }

    func endDayTapped() {
        for meal in sortedMeals {
            if !meal.items.isEmpty && !meal.isCompleted {
                alertMessage = "Are you sure you want to finish the day? Some meals are not completed yet"
                showAlert = true
                return
            }
        }
        confirmEndDay()
    }
    
    func confirmEndDay() {
        guard let currentDayPlan else { return }
        service.endDay(for: currentDayPlan)
        dayRecord = service.getTodayRecord()
    }

    func makeResumeViewModel(with dayRecord: DayRecord) -> TodayResumeViewModel {
        TodayResumeViewModel(dayRecord: dayRecord)
    }

    func getEditWeekViewModel() -> EditWeekViewModel {
        EditWeekViewModel(service: service, dateProvider: dateProvider)
    }

    func getHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(service: service, dateProvider: dateProvider)
    }

    func completeMeal(_ meal: Meal) {
        service.completeMeal(meal)
    }

    private func setViewTitle() {
        let currentHour = Calendar.current.component(.hour, from: Date.now)
        switch currentHour {
        case 6..<12:
            title = "Good morning"
            titleIcon = "sun.horizon"
            titleIconColor = .yellow
        case 12..<18:
            title = "Good afternoon"
            titleIcon = "sun.max"
            titleIconColor = .green
        case 18..<24:
            title = "Good evening"
            titleIcon = "moon.dust"
            titleIconColor = .blue
        default:
            title = "Late night snack?"
            titleIcon = "moon.zzz"
            titleIconColor = .gray
        }
    }

    private func setDateTitle() {
        dateTitle = dateProvider.today.formatted(
            .dateTime
                .weekday(.wide)
                .month(.abbreviated)
                .day()
        )
    }
}
