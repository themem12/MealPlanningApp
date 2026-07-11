//
//  TodayViewModel.swift
//  Orumi
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
    private var foodItemMode: FoodItemViewModel.FoodItemMode = .create
    private var meal: Meal?
    private(set) var selectedFoodItem: FoodItem?
    
    var title = ""
    var titleIcon = ""
    var titleIconColor: Color = .clear
    var dateTitle = ""
    var dayRecord: DayRecord?
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    var addFoodTapped: Bool = false

    var sortedMeals: [Meal] {
        currentDayPlan?.meals.sorted {
            $0.type.order < $1.type.order
        } ?? []
    }

    var isIpad: Bool {
        UIDevice.layout == .ipad
    }

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        self.dateProvider = dateProvider
        loadTodayPlan()
    }

    func loadTodayPlan() {
        dayRecord = service.getTodayRecord()
        currentDayPlan = service.getOrCreatePlan(for: dateProvider.weekDay)
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
                alertTitle = String(localized: "today_view_end_day_alert_title")
                alertMessage = String(localized: "today_view_end_day_alert_message")
                showAlert = true
                return
            }
        }
        confirmEndDay()
    }
    
    func confirmEndDay() {
        guard let currentDayPlan else { return }
        service.endToday(with: currentDayPlan)
        dayRecord = service.getTodayRecord()
    }

    func makeResumeViewModel(with dayRecord: DayRecord) -> TodayResumeViewModel {
        TodayResumeViewModel(dayRecord: dayRecord)
    }

    func makeDebugDataService() -> DebugDataService {
        DebugDataService(mealService: service)
    }

    func getEditWeekContainerViewModel() -> EditWeekContainerViewModel {
        EditWeekContainerViewModel(service: service, dateProvider: dateProvider)
    }

    func getHistoryContainerViewModel() -> HistoryContainerViewModel {
        HistoryContainerViewModel(service: service, dateProvider: dateProvider)
    }

    func completeMeal(_ meal: Meal) {
        service.completeMeal(meal)
    }

    func foodItemTapped(foodItem: FoodItem?, meal: Meal) {
        if let foodItem {
            foodItemMode = .edit(foodItem)
        } else {
            foodItemMode = .create
        }
        self.meal = meal

        addFoodTapped = true
    }

    func getFoodItemViewModel() -> FoodItemViewModel {
        guard let meal else {
            return FoodItemViewModel(mealType: .breakfast) { _ in }
        }
        return FoodItemViewModel(
            mealType: meal.type,
            foodItemMode: foodItemMode
        ) { [weak self] foodItem in
                guard let self else { return }
                switch self.foodItemMode {
                case .create:
                    service.addFoodItem(to: meal, foodItem: foodItem)
                case .edit(_):
                    service.editFoodItem(foodItem)
                }
            }
    }

    private func setViewTitle() {
        let currentHour = Calendar.current.component(.hour, from: Date.now)
        switch currentHour {
        case 6..<12:
            title = String(localized: .todayViewTitleMorning)
            titleIcon = "sun.horizon"
            titleIconColor = .yellow
        case 12..<18:
            title = String(localized: .todayViewTitleAfternoon)
            titleIcon = "sun.max"
            titleIconColor = .orange
        case 18..<24:
            title = String(localized: .todayViewTitleEvening)
            titleIcon = "moon.dust"
            titleIconColor = .blue
        default:
            title = String(localized: .todayViewTitleNight)
            titleIcon = "moon.zzz"
            titleIconColor = .indigo
        }

        title = String(localized: .todayViewTitleMorning)
        titleIcon = "sun.horizon"
        titleIconColor = .yellow
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
