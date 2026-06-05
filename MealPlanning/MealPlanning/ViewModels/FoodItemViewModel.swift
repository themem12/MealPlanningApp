//
//  AddFoodItemViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 15/05/26.
//

import Foundation
import Observation

@Observable
final class FoodItemViewModel {

    enum FoodItemMode {
        case create
        case edit(FoodItem)
    }

    var errorMessage: String?
    var showError = false
    var didSaveFood = false
    var foodField: String = ""
    var amountField: String = ""
    var caloriesField: String = ""

    var buttonTitle: String {
        switch mode {
        case .create:
            return "Add Food"

        case .edit:
            return "Save Changes"
        }
    }

    private let onSave: (FoodItem) -> Void
    private let mode: FoodItemMode
    private(set) var mealType: MealType

    init(mealType: MealType, foodItemMode: FoodItemMode = .create, onSave: @escaping (FoodItem) -> Void) {
        self.mode = foodItemMode
        self.mealType = mealType
        self.onSave = onSave

        switch foodItemMode {
        case .create:
            break
        case .edit(let foodItem):
            foodField = foodItem.name
            amountField = foodItem.portion
            caloriesField = foodItem.calories == 0 ? "" : "\(foodItem.calories)"
        }
    }

    func validateValues() {
        guard validateFoodName(foodField) else {
            errorMessage = "Food name invalid"
            showError = true
            return
        }
        guard validateAmount(amountField) else {
            errorMessage = "Amount invalid"
            showError = true
            return
        }
        guard let caloriesCount = validateCalories(caloriesField) else {
            errorMessage = "Calories invalid"
            showError = true
            return
        }

        switch mode {
        case .create:
            onSave(
                FoodItem(name: foodField, portion: amountField, calories: caloriesCount)
            )
        case .edit(let foodItem):
            foodItem.name = foodField
            foodItem.portion = amountField
            foodItem.calories = caloriesCount
            onSave(foodItem)
        }

        didSaveFood = true
    }

    private func validateFoodName(_ name: String) -> Bool {
        !name.isEmpty
    }

    private func validateAmount(_ amount: String) -> Bool {
        !amount.isEmpty
    }

    private func validateCalories(_ calories: String) -> Int? {
        guard !calories.isEmpty else { return 0 }
        let caloriesCount = Int(calories)
        return caloriesCount
    }
}
