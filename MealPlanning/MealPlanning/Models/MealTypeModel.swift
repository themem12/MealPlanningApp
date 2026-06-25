//
//  MealTypeModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import SwiftUI

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case collationAM
    case collationPM

    var id: String {
        rawValue
    }

    static var completeMealsOrdered: [MealType] {
        [
            .breakfast,
            .collationAM,
            .lunch,
            .collationPM,
            .dinner
        ]
    }

    var title: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .collationAM, .collationPM:
            return "Snack"
        }
    }

    var comment: String {
        switch self {
        case .breakfast:
            return "Start your day well"
        case .lunch:
            return "Time to recharge"
        case .dinner:
            return "A calm end to the day"
        case .collationAM, .collationPM:
            return "A little something in between"
        }
    }

    var color: Color {
        switch self {
        case .breakfast:
            return AppColors.breakfast
        case .lunch:
            return AppColors.lunch
        case .dinner:
            return AppColors.dinner
        case .collationAM, .collationPM:
            return AppColors.snack
        }
    }

    var icon: String {
        switch self {
        case .breakfast:
            "sun.max"
        case .lunch:
            "fork.knife"
        case .dinner:
            "moon.stars.fill"
        case .collationAM:
            "tree.fill"
        case .collationPM:
            "tree.fill"
        }
    }

    var order: Int {
        switch self {
        case .breakfast:
            1
        case .lunch:
            3
        case .dinner:
            5
        case .collationAM:
            2
        case .collationPM:
            4
        }
    }
}
