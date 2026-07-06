//
//  Meal+Fixtures.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 06/07/26.
//

extension Meal {
    static var breakfast: Meal {
        Meal(
            type: .breakfast,
            items: [
                .bread,
                .jam,
                .cheese,
                .beans,
                .fruit,
                .avocado
            ]
        )
    }
    
    static var morningSnack: Meal {
        Meal(
            type: .collationAM,
            items: [
                .oatmeal,
                .milk,
                .fruit,
                .cucumber,
                .almonds
            ]
        )
    }
    
    static var lunch: Meal {
        Meal(
            type: .lunch,
            items: [
                .chicken,
                .vegetable,
                .rice,
                .tortillas,
                .fruit
            ]
        )
    }
    
    static var afternoonSnack: Meal {
        Meal(
            type: .collationPM,
            items: [
                .cucumber
            ]
        )
    }
    
    static var dinner: Meal {
        Meal(
            type: .dinner,
            items: [
                .bread,
                .jam,
                .cheese,
                .fruit,
                .avocado
            ]
        )
    }
}
