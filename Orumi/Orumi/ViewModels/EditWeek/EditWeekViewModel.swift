//
//  EditWeekViewModel.swift
//  Orumi
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

    var addFoodTapped: Bool = false
    private var foodItemMode: FoodItemViewModel.FoodItemMode = .create
    private var meal: Meal?
    private(set) var selectedFoodItem: FoodItem?

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
            return FoodItemViewModel(
                mealType: .breakfast
            ) { _ in }
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
