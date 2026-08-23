//
//  HistoryView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 08/06/26.
//

import SwiftUI

struct HistoryView: View {
    @State private var viewModel: HistoryViewModel
    @State private var selectedDayRecord: DayRecord?

    init(viewModel: HistoryViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(.historyViewTitle)
                    .font(.system(size: 40, weight: .bold))
                Text(.historyViewSubtitle)
                    .font(.system(size: 12, weight: .light))
                
                CalendarView(viewModel: viewModel) { dayProgress in
                    guard dayProgress.dateState != .isFuture else { return }
                    guard dayProgress.dateState != .isToday else { return }
                    if let dayRecord = dayProgress.dayRecord {
                        selectedDayRecord = dayRecord
                    } else {
                        selectedDayRecord = viewModel.getDayRecordFromDayNumber(dayNumber: dayProgress.day)
                    }
                }
                .padding(.top, 24)
            }
            .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxHeight: .infinity)
        .background(AppColors.background)
        .navigationDestination(item: $selectedDayRecord) { dayRecord in
            DayRecordView(
                viewModel: DayRecordViewModel(dayRecord: dayRecord)
            )
        }
    }
}

struct CalendarView: View {
    let viewModel: HistoryViewModel
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    let dayTapped: (DayProgress) -> ()

    var body: some View {
        VStack {
            HStack {
                if !viewModel.isFirstMonth {
                    Button {
                        viewModel.fetchPreviousMonth()
                    } label: {
                        ArrowButton(direction: .left)
                    }.buttonStyle(.plain)
                }

                Spacer()
                Text(viewModel.currentDateTitle)
                    .bold()
                Spacer()
                if !viewModel.isLastMonth {
                    Button {
                        viewModel.fetchNextMonth()
                    } label: {
                        ArrowButton(direction: .right)
                    }.buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(WeekDay.orderedCases) { weekDay in
                    WeekDayCardView(weekDay: weekDay.shortTitle)
                }
                ForEach(viewModel.monthData) { dayProgress in
                    Button {
                        dayTapped(dayProgress)
                    } label: {
                        if dayProgress.day == 0 {
                            EmptyCardView()
                        } else {
                            DayCardView(dayData: dayProgress)
                        }
                    }.buttonStyle(.plain)
                }
            }
            MonthOverviewCard(
                goodDays: viewModel.monthOverview.goodDays,
                regularDays: viewModel.monthOverview.regularDays,
                missedDays: viewModel.monthOverview.missedDays
            ).padding(.top, 24)
        }
    }
}

private struct MonthOverviewCard: View {
    let goodDays: Int
    let regularDays: Int
    let missedDays: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(.historyViewOverviewTitle)
                .bold()
            HStack(spacing: 10) {
                CategoryView(
                    color: AppColors.goodDay,
                    numberOfDays: goodDays,
                    categoryText: String(
                        localized: goodDays == 1 ? .dayStateGood : .dayStateGoodPlural
                    )
                )
                CategoryView(
                    color: AppColors.regularDay,
                    numberOfDays: regularDays,
                    categoryText: String(
                        localized: regularDays == 1 ? .dayStateRegular : .dayStateRegularPlural
                    )
                )
                CategoryView(
                    color: AppColors.missedDay,
                    numberOfDays: missedDays,
                    categoryText: String(
                        localized: missedDays == 1 ? .dayStateMissed : .dayStateMissedPlural
                    )
                )
            }
        }
        .padding()
        .appCardStyle()
    }

    private struct CategoryView: View {
        let color: Color
        let numberOfDays: Int
        let categoryText: String
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                HStack(alignment: .center, spacing: 4) {
                    Text("\(numberOfDays)")
                        .foregroundStyle(color)
                    Text(categoryText.lowercased())
                        .font(.system(size: 12, weight: .light))
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

private struct WeekDayCardView: View {
    let weekDay: String
    var body: some View {
        Text(weekDay)
            .font(.system(size: 14, weight: .heavy))
            .foregroundStyle(.black.opacity(0.4))
    }
}

private struct EmptyCardView: View {
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
    }
}

private struct DayCardView: View {
    let dayData: DayProgress

    var body: some View {
        VStack {
            Text("\(dayData.day)")
                .font(.system(size: 14, weight: .semibold))
            if dayData.dateState == .isPast || dayData.dateState == .isTodayFinished {
                Text(dayData.percentage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(dayData.accentColor)
                    .padding(.top, 4)
            }
        }
        .frame(height: 70)
        .frame(maxWidth: .infinity)
        .background(dayData.accentColor.opacity(0.4))
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    dayData.isToday() ? AppColors.primaryGreen :  .black.opacity(0.1),
                    lineWidth: dayData.isToday() ? 3 : 1
                )
        }
        .shadow(
            color: .black.opacity(0.2),
            radius: 10,
            y: 4
        )
    }
}

private struct ArrowButton: View {
    enum ArrowDirection {
        case left
        case right
    }

    let direction: ArrowDirection

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
            Image(
                systemName:
                    direction == .left ? "chevron.left" : "chevron.right"
            )
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    HistoryView(
        viewModel: HistoryViewModel(
            service: MockMealDataService(),
            dateProvider: DebugDateProvider()
        )
    )
}
