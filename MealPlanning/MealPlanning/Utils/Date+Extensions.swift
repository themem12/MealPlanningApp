//
//  Date+Extensions.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 14/06/26.
//

import Foundation

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var daysInMonth: Int {
        Calendar.current.range(
            of: .day,
            in: .month,
            for: self
        )?.count ?? 0
    }

    func addToDate(_ value: Int, to component: Calendar.Component) -> Date? {
        Calendar.current.date(
            byAdding: .month,
            value: value,
            to: self
        )
    }

    func firstOfMonth() -> Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month],
                from: self
            )
        )!
    }
}
