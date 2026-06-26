//
//  HistoryWideView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 18/06/26.
//

import SwiftUI

struct HistoryWideView: View {

    @State private var historyViewModel: HistoryViewModel

    init(historyViewModel: HistoryViewModel) {
        _historyViewModel = State(
            initialValue: historyViewModel
        )
    }

    var body: some View {
        ScrollView {
            HStack {
                CalendarSideView(
                    viewModel: historyViewModel
                ) { dayProgress in
                    guard dayProgress.dateState != .isFuture else { return }
                    guard dayProgress.dateState != .isToday else { return }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if let dayRecord = dayProgress.dayRecord {
                            historyViewModel.setSelectedDay(record: dayRecord)
                        } else {
                            historyViewModel.setSelectedDay(from: dayProgress.day)
                        }
                    }
                }
                .padding()
                .frame(width: 420)
                
                if let selectedDayRecord = historyViewModel.selectedDayRecord {
                    DayRecordView(
                        viewModel: DayRecordViewModel(dayRecord: selectedDayRecord)
                    )
                    .id(selectedDayRecord.id)
                    .contentTransition(.opacity)
                } else {
                    UnselectedDayView()
                }
            }
        }
        .background(AppColors.background)
        .scrollBounceBehavior(.basedOnSize)
    }
}
private struct CalendarSideView: View {

    let viewModel: HistoryViewModel
    let dayTapped: (DayProgress) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CalendarView(
                viewModel: viewModel,
                dayTapped: dayTapped
            )
            .padding()
            .appSoftCardStyle(background: AppColors.background)
        }
    }

    private struct CategoryView: View {
        let color: Color
        let categoryText: String
        var body: some View {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                HStack(spacing: 0) {
                    Text(categoryText)
                        .font(.system(size: 12, weight: .light))
                }
                Spacer()
            }
        }
    }
}

private struct UnselectedDayView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 170))
                .foregroundStyle(AppColors.primaryGreen)
            Text(.unselectedDayTitle)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
            Text(.unselectedDaySubtitle)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding()
        .frame(
            maxWidth: .infinity, maxHeight: .infinity
        )
    }
}

#Preview {
    HistoryWideView(
        historyViewModel: HistoryViewModel(
            service: MockMealDataService(),
            dateProvider: MockDateProvider(today: .now)
        )
    )
}
