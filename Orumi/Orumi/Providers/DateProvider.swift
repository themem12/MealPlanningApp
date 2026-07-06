//
//  DateProvider.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 29/05/26.
//

import Foundation

protocol DateProvider {
    var today: Date { get }
    var weekDay: WeekDay { get }
}

struct LiveDateProvider: DateProvider {
    var today: Date {
        Calendar.current.startOfDay(for: Date())
    }

    var weekDay: WeekDay {
        WeekDay(rawValue: Calendar.current.component(.weekday, from: today)) ?? .monday
    }
}

struct MockDateProvider: DateProvider {
    let today: Date
    var weekDay: WeekDay {
        WeekDay(rawValue: Calendar.current.component(.weekday, from: today)) ?? .monday
    }
}
