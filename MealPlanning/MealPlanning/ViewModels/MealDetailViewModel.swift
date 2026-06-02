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
    private(set) var meal: Meal

    init(service: MealDataServiceProtocol, meal: Meal) {
        self.service = service
        self.meal = meal
    }

    func addFoodItem(_ foodItem: FoodItem) {
        service.addFoodItem(to: meal, foodItem: foodItem)
    }
}
