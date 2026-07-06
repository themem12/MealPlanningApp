//
//  AppInputField.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 03/06/26.
//

import SwiftUI

struct AppInputField: View {
    let placeholder: String
    let icon: String

    var keyboardType: UIKeyboardType = .default
    var accentColor: Color = AppColors.primaryGreen
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(accentColor)

                TextField(
                    placeholder,
                    text: $text
                ).foregroundStyle(AppColors.secondaryText)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(accentColor, lineWidth: 1)
            }
        }
    }
}
