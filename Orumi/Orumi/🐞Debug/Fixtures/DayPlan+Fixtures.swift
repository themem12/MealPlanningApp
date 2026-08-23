//
//  DayPlan+Fixtures.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 06/07/26.
//

extension DayPlan {
    static let monday = DayPlan(day: .monday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let tuesday = DayPlan(day: .tuesday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let wednesday = DayPlan(day: .wednesday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let thursday = DayPlan(day: .thursday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let friday = DayPlan(day: .friday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let saturday = DayPlan(day: .saturday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static let sunday = DayPlan(day: .sunday, meals: [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner])

    static func getDayPlanFrom(weekDay: WeekDay) -> DayPlan {
        switch weekDay {
        case .sunday:
                .sunday
        case .monday:
                .monday
        case .tuesday:
                .tuesday
        case .wednesday:
                .wednesday
        case .thursday:
                .thursday
        case .friday:
                .friday
        case .saturday:
                .saturday
        }
    }
}
