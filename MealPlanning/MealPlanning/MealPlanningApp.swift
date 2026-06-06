//
//  MealPlanningApp.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import SwiftUI
import SwiftData

@main
struct MealPlanningApp: App {
    
    let sharedModelContainer: ModelContainer
    let service: MealDataServiceProtocol
    let dateProvider: DateProvider
    
    init() {
        let schema = Schema([
            DayPlan.self,
            Meal.self,
            FoodItem.self,
            DayRecord.self,
            MealRecord.self,
            FoodItemRecord.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            sharedModelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            
            let context = ModelContext(sharedModelContainer)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"

            let debugDay = formatter.date(from: "2026/06/6")!

//            dateProvider = MockDateProvider(today: debugDay)
            dateProvider = LiveDateProvider()
            
            service = LiveMealDataService(
                context: context,
                dateProvider: dateProvider
            )
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TodayView(
                viewModel:
                    TodayViewModel(
                        service: service,
                        dateProvider: dateProvider
                    )
            )
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
