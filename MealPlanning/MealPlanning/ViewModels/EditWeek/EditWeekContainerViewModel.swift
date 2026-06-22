//
//  EditWeekContainerViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 22/06/26.
//

final class EditWeekContainerViewModel {
    private let service: MealDataServiceProtocol
    private let dateProvider: DateProvider

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        self.dateProvider = dateProvider
    }
    
    func getEditWeekViewModel() -> EditWeekViewModel {
        EditWeekViewModel(
            service: service,
            dateProvider: dateProvider
        )
    }

    func getEditWeekWideViewModel() -> EditWeekWideViewModel {
        EditWeekWideViewModel(
            service: service,
            dateProvider: dateProvider
        )
    }
}
