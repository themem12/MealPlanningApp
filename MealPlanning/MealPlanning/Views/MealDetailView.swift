//
//  MealDetailView.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 30/04/26.
//

import SwiftUI
import SwiftData

struct MealDetailView: View {

    @State private var showAddFoodSheet: Bool = false
    private let viewModel: MealDetailViewModel

    init(viewModel: MealDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(viewModel.meal.type.rawValue.uppercased())
                .font(.title)
                .bold()
            Spacer()
            ForEach(viewModel.meal.items) { item in
                Group {
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.portion)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddFoodSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddFoodSheet) {
            AddFoodItemView(
                viewModel: AddFoodItemViewModel(onSave: { foodItem in
                    viewModel.addFoodItem(foodItem)
                })
            )
        }
    }
}

#Preview {
    MealDetailView(
        viewModel: MealDetailViewModel(
            service: MockMealDataService(),
            meal: Meal(
                type: .breakfast,
                items: [
                    FoodItem(name: "Chicken", portion: "123 gr", calories: 150)
                ]
            )
        )
    )
}
