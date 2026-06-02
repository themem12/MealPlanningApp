//
//  AddFoodItemViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 15/05/26.
//

import Foundation
import Observation

@Observable
final class AddFoodItemViewModel {

    var errorMessage: String?
    var showError = false
    var didSaveFood = false

    private let onSave: (FoodItem) -> Void

    init(onSave: @escaping (FoodItem) -> Void) {
        self.onSave = onSave
    }

    func validateValues(foodName: String, amount: String, calories: String) {
        guard validateFoodName(foodName) else {
            errorMessage = "Food name invalid"
            showError = true
            return
        }
        guard validateAmount(amount) else {
            errorMessage = "Amount invalid"
            showError = true
            return
        }
        guard let caloriesCount = validateCalories(calories) else {
            errorMessage = "Calories invalid"
            showError = true
            return
        }

        

        onSave(
            FoodItem(name: foodName, portion: amount, calories: caloriesCount)
        )

        didSaveFood = true
    }

    private func validateFoodName(_ name: String) -> Bool {
        !name.isEmpty
    }

    private func validateAmount(_ amount: String) -> Bool {
        !amount.isEmpty
    }

    private func validateCalories(_ calories: String) -> Int? {
        guard !calories.isEmpty else { return nil }
        let caloriesCount = Int(calories)
        return caloriesCount
    }
}
