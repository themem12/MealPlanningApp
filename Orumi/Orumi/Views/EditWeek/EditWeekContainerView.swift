//
//  EditWeekContainerView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 22/06/26.
//

import SwiftUI

struct EditWeekContainerView: View {

    let viewModel: EditWeekContainerViewModel

    var body: some View {
        GeometryReader { geometry in
            switch geometry.size.width.layoutMode {
            case .compact:
                EditWeekView(viewModel: viewModel.getEditWeekViewModel())
            case .wide:
                EditWeekWideView(
                    editWeekViewModel: viewModel.getEditWeekWideViewModel()
                )
            }
        }
    }
}

#Preview {
    EditWeekContainerView(
        viewModel: EditWeekContainerViewModel(
            service: MockMealDataService(),
            dateProvider: DebugDateProvider()
        )
    )
}
