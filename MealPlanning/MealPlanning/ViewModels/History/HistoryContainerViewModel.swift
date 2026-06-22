//
//  HistoryContainerViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 18/06/26.
//

import Observation

final class HistoryContainerViewModel {
    private let service: MealDataServiceProtocol
    private let dateProvider: DateProvider

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        self.dateProvider = dateProvider
    }

    func getHistoryCompactViewModel() -> HistoryViewModel {
        HistoryViewModel(service: service, dateProvider: dateProvider)
    }
}
