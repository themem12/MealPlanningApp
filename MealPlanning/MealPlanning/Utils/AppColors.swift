//
//  AppColors.swift
//  MealPlanning
//
//  Created by Guillermo Saavedra Dorantes  on 31/05/26.
//

import SwiftUI

enum AppColors {

    // MARK: - Backgrounds

    static let background = Color(hex: "#F5F6F2")
    static let card = Color(hex: "#FFFFFF")

    // MARK: - Greens

    static let primaryGreen = Color(hex: "#7FA37C")
    static let deepGreen = Color(hex: "#2F4F3A")
    static let softSage = Color(hex: "#DCE8D8")

    // MARK: - Text

    static let primaryText = Color(hex: "#243127")
    static let secondaryText = Color(hex: "#6F786D")

    // MARK: - Borders

    static let border = Color(hex: "#E5E8E1")

    // MARK: - States

    static let success = Color(hex: "#6BBF73")
    static let warning = Color(hex: "#E7C98B")

    // MARK: - Meal Theme

    static let breakfast = Color(hex: "#EEBB2E")
    static let snack = Color(hex: "#87A4D5")
    static let lunch = Color(hex: "#4CAF50")
    static let dinner = Color(hex: "#8E77C5")

    // MARK: - Day State

    static let goodDay = Color(hex: "#5A9A59")
    static let regularDay = Color(hex: "#B88B00")
    static let missedDay = Color(hex: "#D65A4A")
}

extension Color {

    init(hex: String) {

        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64

        switch hex.count {

        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )

        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
