//
//  MealDetailViewModel.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 12/05/26.
//

import Foundation
import Observation

@Observable
final class MealDetailViewModel {

    private let service: MealDataServiceProtocol
    private var foodItemMode: FoodItemViewModel.FoodItemMode = .create
    private var foodItemPendingDeletion: FoodItem?
    private(set) var meal: Meal

    var showAddFoodSheet: Bool = false
    var showDeleteConfirmation: Bool = false

    init(service: MealDataServiceProtocol, meal: Meal) {
        self.service = service
        self.meal = meal
    }

    func deleteFoodItemTapped(_ foodItem: FoodItem) {
        foodItemPendingDeletion = foodItem
        showDeleteConfirmation = true
    }

    func deleteFoodItemConfirmed() {
        guard let foodItem = foodItemPendingDeletion else { return }
        service.deleteFoodItem(foodItem, from: meal)
    }
}
