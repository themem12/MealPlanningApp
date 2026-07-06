//
//  Arrays+Extensions.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 30/06/26.
//

extension Array where Element: Equatable {

    /// Checks if the element is the first one in an Array
    func isFirst(_ element: Element) -> Bool {
        first == element
    }

    /// Checks if the element is the last one in an Array
    func isLast(_ element: Element) -> Bool {
        last == element
    }
}
