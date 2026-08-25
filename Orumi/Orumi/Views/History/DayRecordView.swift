//
//  DayRecordView.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 11/06/26.
//

import SwiftUI

struct DayRecordView: View {

    @State private var viewModel: DayRecordViewModel

    init(viewModel: DayRecordViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.dayTitle)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                Spacer()
                Text(viewModel.dayStateTitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(viewModel.dayStateColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.dayStateColor.opacity(0.2))
                    }
            }.padding(.horizontal)
            Text(viewModel.dateTitle)
                .font(.headline)
                .foregroundStyle(AppColors.primaryText)
                .padding(.horizontal)
            if !viewModel.isEmpty {
                Label(
                    viewModel.completedDaysTitle,
                    systemImage: "checkmark"
                )
                .font(.callout)
                .foregroundStyle(AppColors.primaryText)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppColors.primaryGreen.opacity(0.2))
                }
                .padding(.horizontal)

                ScrollView {
                    ForEach(viewModel.meals) { meal in
                        MealCard(meal: meal, isRecord: true)
                            .padding(.horizontal)
                            .padding(.top, viewModel.meals.isFirst(meal) ? SpaceSize.medium.rawValue : SpaceSize.small.rawValue)
                            .padding(.bottom, viewModel.meals.isLast(meal) ? SpaceSize.medium.rawValue : SpaceSize.small.rawValue)
                    }
                }
            } else {
                Spacer()
                EmptyRecordDayView()
                Spacer()
            }
        }
        .padding(.top)
        .background(AppColors.background)
    }
}

#Preview {
    DayRecordView(
        viewModel: DayRecordViewModel(
            dayRecord: DayRecord(date: .now, from: .init(day: .monday, meals: []), isCompleted: false)
        )
    )
}
