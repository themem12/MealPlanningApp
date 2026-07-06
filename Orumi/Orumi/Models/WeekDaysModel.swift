//
//  WeekDaysModel.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 27/04/26.
//

import Foundation

enum WeekDay: Int, Codable, CaseIterable, Identifiable {

    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .sunday:
            return String(localized: .weekdayLongSunday)
        case .monday:
            return String(localized: .weekdayLongMonday)
        case .tuesday:
            return String(localized: .weekdayLongTuesday)
        case .wednesday:
            return String(localized: .weekdayLongWednesday)
        case .thursday:
            return String(localized: .weekdayLongThursday)
        case .friday:
            return String(localized: .weekdayLongFriday)
        case .saturday:
            return String(localized: .weekdayLongSaturday)
        }
    }

    var shortTitle: String {
        switch self {
        case .sunday:
            return String(localized: .weekdayShortSunday)
        case .monday:
            return String(localized: .weekdayShortMonday)
        case .tuesday:
            return String(localized: .weekdayShortTuesday)
        case .wednesday:
            return String(localized: .weekdayShortWednesday)
        case .thursday:
            return String(localized: .weekdayShortThursday)
        case .friday:
            return String(localized: .weekdayShortFriday)
        case .saturday:
            return String(localized: .weekdayShortSaturday)
        }
    }

    static var orderedCases: [WeekDay] {
        [
            .monday,
            .tuesday,
            .wednesday,
            .thursday,
            .friday,
            .saturday,
            .sunday
        ]
    }
}
