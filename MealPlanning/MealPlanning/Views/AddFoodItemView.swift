//
//  AddFoodItemView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 04/05/26.
//

import SwiftUI

struct AddFoodItemView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var foodField: String = ""
    @State private var amountField: String = ""
    @State private var caloriesField: String = ""
    @State private var viewModel: AddFoodItemViewModel

    init(viewModel: AddFoodItemViewModel) {
        _viewModel = State(
            initialValue: viewModel
        )
    }

    var body: some View {
        VStack {
            TextField("Food", text: $foodField)
                .textFieldStyle(.roundedBorder)
            TextField("Amount", text: $amountField)
                .textFieldStyle(.roundedBorder)
            TextField("Calories", text: $caloriesField)
                .textFieldStyle(.roundedBorder)
            Button {
                viewModel.validateValues(
                    foodName: foodField,
                    amount: amountField,
                    calories: caloriesField
                )
            } label: {
                Text("Add food")
            }
        }
        .padding()
        .presentationDetents([.medium])
        .onChange(of: viewModel.didSaveFood) {
            dismiss()
        }
        .alert(
            "Error",
            isPresented: $viewModel.showError
        ){
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    AddFoodItemView(
        viewModel: AddFoodItemViewModel(onSave: { _ in})
    )
}
