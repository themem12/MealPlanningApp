//
//  Image+Extensions.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 24/06/26.
//

import SwiftUI

extension View {
    /// Applies a square frame using a predefined icon size.
    ///
    /// Example:
    /// ```swift
    /// Image(systemName: "sun.max")
    ///     .iconSize(.medium)
    /// ```
    ///
    /// - Parameter size: The icon size to apply.
    /// - Returns: A view constrained to the specified width and height.
    func iconSize(_ size: IconSize) -> some View {
        self
            .frame(width: size.rawValue, height: size.rawValue)
            .font(.system(size: size.rawValue))
    }
}
