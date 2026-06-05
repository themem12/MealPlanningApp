//
//  MealDetailViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 12/05/26.
//

import Foundation
import Observation

@Observable
final class MealDetailViewModel {

    private let service: MealDataServiceProtocol
    private var foodItemMode: FoodItemViewModel.FoodItemMode = .create
    private(set) var meal: Meal
    var showAddFoodSheet: Bool = false

    init(service: MealDataServiceProtocol, meal: Meal) {
        self.service = service
        self.meal = meal
    }
    
    func addFoodItemTapped() {
        foodItemMode = .create
        showAddFoodSheet = true
    }

    func editFoodItemTapped(_ foodItem: FoodItem) {
        foodItemMode = .edit(foodItem)
        showAddFoodSheet = true
    }

    func getFoodItemViewModel() -> FoodItemViewModel {
        FoodItemViewModel(
            mealType: meal.type,
            foodItemMode: foodItemMode) { [weak self] foodItem in
                guard let self else { return }
                switch self.foodItemMode {
                case .create:
                    service.addFoodItem(to: self.meal, foodItem: foodItem)
                case .edit(_):
                    service.editFoodItem(foodItem)
                }
            }
    }
}
