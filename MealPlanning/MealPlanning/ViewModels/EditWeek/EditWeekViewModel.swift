//
//  EditWeekViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 31/05/26.
//

import Observation

@Observable
class EditWeekViewModel {

    var meals: [Meal] = []
    let service: MealDataServiceProtocol
    var selectedDay: WeekDay?
    let dateProvider: DateProvider

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        self.selectedDay = dateProvider.weekDay
        self.dateProvider = dateProvider
    }

    func selectDay(_ weekDay: WeekDay) {
        if selectedDay == weekDay {
            selectedDay = nil
        } else {
            selectedDay = weekDay
        }
    }

    func dayIsSelected(_ weekDay: WeekDay) -> Bool {
        weekDay == selectedDay
    }

    func isCurrentDay(_ weekDay: WeekDay) -> Bool {
        weekDay == dateProvider.weekDay
    }

    func getMealsFor(weekDay: WeekDay) -> [Meal] {
        service
            .getOrCreatePlan(for: weekDay)
            .meals
    }

    func getMealsCountFor(weekDay: WeekDay) -> Int {
        service.getOrCreatePlan(for: weekDay).meals
            .filter { !$0.items.isEmpty }.count
    }

    func makeMealDetailViewModel(for meal: Meal) -> MealDetailViewModel {
        return MealDetailViewModel(
            service: service,
            meal: meal
        )
    }
}

@Observable
final class EditWeekWideViewModel: EditWeekViewModel {

    func getMealsFromSelectedDay() -> [Meal] {
        getMealsFor(weekDay: getSelectedDay())
    }

    func getSelectedDay() -> WeekDay {
        selectedDay ?? dateProvider.weekDay
    }
}
