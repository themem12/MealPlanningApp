//
//  Device+Extensions.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 14/06/26.
//

import UIKit

enum DeviceLayout {
    case phone
    case ipad
}

extension UIDevice {
    static var layout: DeviceLayout {
        UIDevice.current.userInterfaceIdiom == .pad ? .ipad : .phone
    }
}
