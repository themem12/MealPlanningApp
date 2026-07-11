//
//  DebugPreset.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 06/07/26.
//

enum DebugPreset: String, CaseIterable, Identifiable {
    case firstLaunch
    case perfectWeek
    case fillWeekPlans
    case mockupPlans
    case deleteAll

    var id: Self { self }

    var title: String {
        switch self {
        case .firstLaunch:
            "First Launch"

        case .perfectWeek:
            "Perfect Week"
        case .fillWeekPlans:
            "Fill Week Plans"
        case .mockupPlans:
            "Instagram plans 💅🏼"
        case .deleteAll:
            "🚨🚨 Delete all 💣 🚨🚨"
        }
    }
}
