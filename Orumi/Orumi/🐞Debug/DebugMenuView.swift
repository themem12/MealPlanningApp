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
                ForEach(DebugPreset.allCases) { preset in
                    Button {
                        debugService.load(preset)
                    } label: {
                        Text(preset.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.glassProminent)
                }
            }
        }.padding()
    }
}

#Preview {
    DebugMenuView(
        debugService:
            DebugDataService(mealService: MockMealDataService(), debugDateProvider: DebugDateProvider())
    )
}
