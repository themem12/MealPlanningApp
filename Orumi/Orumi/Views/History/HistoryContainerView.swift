//
//  HistoryContainerView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 18/06/26.
//

import SwiftUI

struct HistoryContainerView: View {
    @State private var viewModel: HistoryContainerViewModel

    init(viewModel: HistoryContainerViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            switch geometry.size.width.layoutMode {
            case .compact:
                HistoryView(
                    viewModel: viewModel.getHistoryCompactViewModel()
                )
            case .wide:
                HistoryWideView(
                    historyViewModel: viewModel.getHistoryCompactViewModel()
                )
            }
        }
    }
}

#Preview {
    HistoryContainerView(
        viewModel: HistoryContainerViewModel(
            service: MockMealDataService(), dateProvider: MockDateProvider(today: .now)
        )
    )
}
