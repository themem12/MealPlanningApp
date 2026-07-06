//
//  DebugMenuView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 06/07/26.
//

import SwiftUI

struct DebugMenuView: View {

    let debugService: DebugDataService

    var body: some View {
        ScrollView {
            VStack {
                Button {
                    debugService.load(.fillWeekPlans)
                } label: {
                    Text("Set complete DayPlans")
                }

            }
        }.padding()
    }
}

#Preview {
    DebugMenuView(
        debugService: DebugDataService(mealService: MockMealDataService())
    )
}
