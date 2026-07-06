//
//  Layout.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 18/06/26.
//

import Foundation

enum LayoutMode {
    case compact
    case wide
}

extension CGFloat {
    var layoutMode: LayoutMode {
        self > 900 ? .wide : .compact
    }
}

