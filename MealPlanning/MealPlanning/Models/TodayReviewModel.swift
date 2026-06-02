//
//  TodayReviewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 24/05/26.
//

import Foundation

struct TodayReviewMealModel: Identifiable {
    let id = UUID()
    
    let mealType: MealType
    let isCompleted: Bool
}
