//
//  OrumiApp.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import SwiftUI
import SwiftData

@main
struct OrumiApp: App {

    @Environment(\.scenePhase) private var scenePhase

    let sharedModelContainer: ModelContainer
    let service: MealDataServiceProtocol
    let historyMaintenanceService: HistoryMaintenanceServiceProtocol
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

//            let debugDay = formatter.date(from: "2026/07/13")!
//            dateProvider = MockDateProvider(today: debugDay)

            dateProvider = LiveDateProvider()
            
            service = LiveMealDataService(
                context: context,
                dateProvider: dateProvider
            )

//            for weekDay in WeekDay.orderedCases {
//                let dayPlan = service.getOrCreatePlan(for: weekDay)
//                for meal in dayPlan.meals {
//                    service.addFoodItem(
//                        to: meal, foodItem: FoodItem(
//                            name: "\(meal.type.title), \(weekDay.title)", portion: "123 gr"
//                        )
//                    )
//                }
//            }

            historyMaintenanceService = LiveHistoryMaintenanceService(
                mealService: service,
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
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                historyMaintenanceService.processPendingDays()
            }
        }
    }
}
