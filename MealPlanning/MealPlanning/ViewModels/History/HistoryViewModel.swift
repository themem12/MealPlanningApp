//
//  HistoryViewModel.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 09/06/26.
//
import Observation
import SwiftUI

@Observable
final class HistoryViewModel {

    struct MonthOverviewData {
        let missedDays: Int
        let goodDays: Int
        let regularDays: Int
    }

    private let service: MealDataServiceProtocol
    private let dateProvider: DateProvider
    private var selectedMonth: Date = .now {
        didSet {
            loadMonth()
        }
    }

    private(set) var monthData: [DayProgress] = []
    private(set) var currentDateTitle: String = ""
    private(set) var isFirstMonth: Bool = false
    private(set) var isLastMonth: Bool = false
    private(set) var monthOverview: MonthOverviewData = .init(missedDays: 0, goodDays: 0, regularDays: 0)
    private(set) var selectedDayRecord: DayRecord?

    init(service: MealDataServiceProtocol, dateProvider: DateProvider) {
        self.service = service
        self.dateProvider = dateProvider
        selectedMonth = dateProvider.today.firstOfMonth()
        loadMonth()
    }

    func fetchNextMonth() {
        selectedMonth = selectedMonth.addToDate(1, to: .month) ?? selectedMonth
    }

    func fetchPreviousMonth() {
        selectedMonth = selectedMonth.addToDate(-1, to: .month) ?? selectedMonth
    }

    func getDayRecordFromDayNumber(dayNumber: Int) -> DayRecord {

        let date = Calendar.current.date(
            from: DateComponents(year: selectedMonth.year, month: selectedMonth.month, day: dayNumber)
        ) ?? .now

        return DayRecord(date: date)
    }

    func setSelectedDay(record: DayRecord) {
        selectedDayRecord = record
    }

    func setSelectedDay(from day: Int) {
        selectedDayRecord = getDayRecordFromDayNumber(dayNumber: day)
    }

    private func loadMonth() {
        // Clear month data before adding more data
        monthData = []

        setCurrentDate()

        setCalendarNavigation()

        let records = service.getMonthRecord(month: selectedMonth)
        var badDays = 0
        var goodDays = 0
        var regularDays = 0

        getEmptySpaces()

        for day in 1...selectedMonth.daysInMonth {
            if let dayRecord = records.filter({ $0.date.day == day }).first {
                var percentage = "-"
                var accentColor: Color = .gray

                let actualMeals = dayRecord.meals.filter({ !$0.items.isEmpty})
                if actualMeals.count > 0 {
                    let completedMeals = actualMeals.filter({ $0.isCompleted }).count
                    let totalMeals = actualMeals.count
                    percentage = String(localized: .mealsFraction(completedMeals, totalMeals))
                    if completedMeals == 0 {
                        accentColor = AppColors.missedDay
                        badDays += 1
                    } else if completedMeals >= totalMeals - 1 {
                        accentColor = AppColors.goodDay
                        goodDays += 1
                    } else if completedMeals >= totalMeals / 2 {
                        accentColor = AppColors.regularDay
                        regularDays += 1
                    } else {
                        accentColor = AppColors.missedDay
                        badDays += 1
                    }
                }

                let dateState = getDateState(for: dayRecord.date)

                monthData.append(DayProgress(
                    day: day,
                    percentage: percentage,
                    accentColor: accentColor,
                    dateState: dateState == .isToday ? .isTodayFinished : dateState,
                    dayRecord: dayRecord
                ))
            } else {
                let cellDate = Calendar.current.date(
                    from: DateComponents(
                        year: selectedMonth.year,
                        month: selectedMonth.month,
                        day: day
                    )
                )!

                let dateState = getDateState(for: cellDate)
                let posibleStates: [DayProgress.DateState] = [.isToday, .isFuture]
                let accentColor: Color = posibleStates.contains(dateState) ? .white : .gray
                
                monthData.append(
                    DayProgress(
                        day: day,
                        percentage: "-",
                        accentColor: accentColor,
                        dateState: dateState,
                        dayRecord: nil
                    )
                )
            }
        }

        monthOverview = MonthOverviewData(
            missedDays: badDays,
            goodDays: goodDays,
            regularDays: regularDays
        )
    }

    private func getEmptySpaces() {
        

        let weekday = Calendar.current.component(
            .weekday,
            from: selectedMonth.firstOfMonth()
        )

        var emptySpaces = 0
        switch weekday {
        case 1: // Sunday
            emptySpaces = 6
        case 2: // Monday
            emptySpaces = 0
        case 3: // Tuesday
            emptySpaces = 1
        case 4: // Wednesday
            emptySpaces = 2
        case 5: // Thursday
            emptySpaces = 3
        case 6: // Friday
            emptySpaces = 4
        case 7: // Saturday
            emptySpaces = 5
        default:
            break
        }

        monthData.append(
            contentsOf: (0..<emptySpaces).map { _ in
                DayProgress(
                    day: 0,
                    percentage: "",
                    accentColor: .clear,
                    dateState: .isPast,
                    dayRecord: nil
                )
            }
        )
    }

    private func setCurrentDate() {
        currentDateTitle = selectedMonth.formatted(
            .dateTime.month(.wide).year()
        ).capitalized
    }

    private func getDateState(for date: Date) -> DayProgress.DateState {
        if Calendar.current.isDate(date, inSameDayAs: dateProvider.today) {
            return .isToday
        } else if date > dateProvider.today {
            return .isFuture
        } else {
            return .isPast
        }
    }

    private func setCalendarNavigation() {
        // For lastMonth we validate if the selected month is the same as the system month
        let firstDayOfCurrentMonth = dateProvider.today.firstOfMonth()

        isLastMonth = Calendar.current.isDate(selectedMonth, inSameDayAs: firstDayOfCurrentMonth)

        // For firstMonth we need to validate le previous month has at least one record
        guard let previousMonth = selectedMonth.addToDate(-1, to: .month) else {
            isFirstMonth = true
            return
        }

        let previousMonthRecords = service.getMonthRecord(month: previousMonth)
    
        isFirstMonth = previousMonthRecords.isEmpty
    }
}

struct DayProgress: Identifiable {
    enum DateState {
        case isToday
        case isTodayFinished
        case isFuture
        case isPast
    }
    let id = UUID()
    let day: Int
    let percentage: String
    let accentColor: Color
    let dateState: DateState
    let dayRecord: DayRecord?

    func isToday() -> Bool {
        switch dateState {
        case .isToday, .isTodayFinished:
            return true
        default: return false
        }
    }
}
