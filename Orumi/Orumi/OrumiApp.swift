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

    @State private var showDebugMenu: Bool = false

    let sharedModelContainer: ModelContainer
    let service: MealDataServiceProtocol
    let historyMaintenanceService: HistoryMaintenanceServiceProtocol
    let dateProvider: DebugDateProvider
    let debugDataService: DebugDataService
    
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

            dateProvider = DebugDateProvider()

            service = LiveMealDataService(
                context: context,
                dateProvider: dateProvider
            )

            historyMaintenanceService = LiveHistoryMaintenanceService(
                mealService: service,
                dateProvider: dateProvider
            )

            debugDataService = DebugDataService(
                mealService: service,
                debugDateProvider: dateProvider
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
#if DEBUG
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Spacer()
                    Button {
                        showDebugMenu = true
                    } label: {
                        Image(systemName: "ladybug")
                            .font(.system(size: 30))
                            .background(.red)
                            .clipShape(.circle)
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
            }
            .sheet(isPresented: $showDebugMenu, content: {
                DebugMenuView(
                    debugService: debugDataService
                )
            })
#endif
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                historyMaintenanceService.processPendingDays()
            }
        }
    }
}
