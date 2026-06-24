//
//  AddFoodItemView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 04/05/26.
//

import SwiftUI

struct FoodItemView: View {

    enum Field {
        case foodName
        case portion
        case calories
    }

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: FoodItemViewModel
    
    @FocusState private var focusedField: Field?

    init(viewModel: FoodItemViewModel) {
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
            
            AppInputField(
                placeholder: "Food Name",
                icon: "fork.knife",
                accentColor: viewModel.mealType.color,
                text: $viewModel.foodField
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
                text: $viewModel.amountField
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
                text: $viewModel.caloriesField
            )
            .focused($focusedField, equals: .calories)
            .submitLabel(.next)
            .onSubmit {
                focusedField = nil
            }
            
            Button {
                viewModel.validateValues()
            } label: {
                Text(viewModel.buttonTitle)
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
    FoodItemView(
        viewModel: FoodItemViewModel(mealType: .breakfast, onSave: { _ in})
    )
}
