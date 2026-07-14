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

final class DebugDateProvider: DateProvider {

    enum Mode {
        case live
        case custom(Date)
    }

    private let liveProvider = LiveDateProvider()
    private var mode: Mode = .live

    var today: Date {
        switch mode {
        case .live:
            return liveProvider.today
        case .custom(let date):
            return date
        }
    }

    var weekDay: WeekDay {
        WeekDay(rawValue: Calendar.current.component(.weekday, from: today)) ?? .monday
    }

    func useLive() {
        mode = .live
    }
    
    func useMock(date: Date) {
        mode = .custom(date)
    }
}
