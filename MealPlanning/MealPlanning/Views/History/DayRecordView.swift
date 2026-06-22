//
//  DayRecordView.swift
//  MealPlanning
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
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(viewModel.dayStateColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.dayStateColor.opacity(0.2))
                    }
            }
            Text(viewModel.dateTitle)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(AppColors.primaryText)
            if !viewModel.isEmpty {
                Label(
                    viewModel.completedDaysTitle,
                    systemImage: "checkmark"
                )
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(AppColors.primaryText)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppColors.primaryGreen.opacity(0.2))
                }

                ScrollView {
                    ForEach(viewModel.meals) { meal in
                        MealCard(meal: meal, isRecord: true) { }
                    }
                }
                .padding(.top)
            } else {
                Spacer()
                EmptyRecordDayView()
                Spacer()
            }
        }
        .padding()
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
