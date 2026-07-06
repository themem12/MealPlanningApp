//
//  AddFoodItemViewModel.swift
//  Orumi
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

    var buttonTitle: String {
        switch mode {
        case .create:
            return String(localized: .foodItemViewAddButton)

        case .edit:
            return String(localized: .foodItemViewEditButton)
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
        }
    }

    func validateValues() {
        guard validateFoodName(foodField) else {
            errorMessage = String(localized: .foodItemViewWarningMessageName)
            showError = true
            return
        }
        guard validateAmount(amountField) else {
            errorMessage = String(localized: .foodItemViewWarningMessageAmount)
            showError = true
            return
        }

        switch mode {
        case .create:
            onSave(
                FoodItem(name: foodField, portion: amountField)
            )
        case .edit(let foodItem):
            foodItem.name = foodField
            foodItem.portion = amountField
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
}
