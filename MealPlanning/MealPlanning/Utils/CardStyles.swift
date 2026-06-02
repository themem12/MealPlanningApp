//
//  CardStyles.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 01/06/26.
//

import SwiftUI

struct AppCardStyle: ViewModifier {

    func body(content: Content) -> some View {

        content
            .background(AppColors.card)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        AppColors.border.opacity(0.8),
                        lineWidth: 1
                    )
            }
            .shadow(
                color: .black.opacity(0.1),
                radius: 10,
                y: 4
            )
    }
}

struct SoftCardStyle: ViewModifier {

    let background: Color

    func body(content: Content) -> some View {

        content
            .background(background)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        AppColors.border.opacity(0.6),
                        lineWidth: 1
                    )
            }
            .shadow(
                color: .black.opacity(0.02),
                radius: 8,
                y: 3
            )
    }
}

extension View {

    func appCardStyle() -> some View {
        modifier(AppCardStyle())
    }

    func appSoftCardStyle(background: Color) -> some View {
        modifier(SoftCardStyle(background: background))
    }
}
