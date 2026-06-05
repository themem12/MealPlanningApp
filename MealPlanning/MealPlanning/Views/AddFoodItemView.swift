//
//  AddFoodItemView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 04/05/26.
//

import SwiftUI

struct AddFoodItemView: View {

    enum Field {
        case foodName
        case portion
        case calories
    }

    @Environment(\.dismiss) private var dismiss
    @State private var foodField: String = ""
    @State private var amountField: String = ""
    @State private var caloriesField: String = ""
    @State private var viewModel: AddFoodItemViewModel
    
    @FocusState private var focusedField: Field?

    init(viewModel: AddFoodItemViewModel) {
        _viewModel = State(
            initialValue: viewModel
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(viewModel.mealType.color.opacity(0.4))
                    Image(systemName: viewModel.mealType.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(viewModel.mealType.color)
                }
                Text(viewModel.mealType.title)
                    .font(.title2.weight(.semibold))
            }
            .padding(.top)
            Spacer()
            AppInputField(
                placeholder: "Food Name",
                icon: "fork.knife",
                accentColor: viewModel.mealType.color,
                text: $foodField
            )
            .focused($focusedField, equals: .foodName)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .portion
            }
            AppInputField(
                placeholder: "Portion",
                icon: "scalemass",
                accentColor: viewModel.mealType.color,
                text: $amountField
            )
            .focused($focusedField, equals: .portion)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .calories
            }
            AppInputField(
                placeholder: "Calories (optional)",
                icon: "flame",
                keyboardType: .numberPad,
                accentColor: viewModel.mealType.color,
                text: $caloriesField
            )
            .focused($focusedField, equals: .calories)
            .submitLabel(.next)
            .onSubmit {
                focusedField = nil
            }
            Spacer()
            Button {
                viewModel.validateValues(
                    foodName: foodField,
                    amount: amountField,
                    calories: caloriesField
                )
            } label: {
                Text("Add Food")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(viewModel.mealType.color)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
        .presentationDetents([.medium])
        .onAppear() {
            focusedField = .foodName
        }
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
        viewModel: AddFoodItemViewModel(mealType: .breakfast, onSave: { _ in})
    )
}
