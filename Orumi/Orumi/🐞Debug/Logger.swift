//
//  Logger.swift
//  Orumi
//
//  Created by Guillermo Saavedra Dorantes  on 14/07/26.
//

enum Log {

    static func debug(
        _ message: @autoclosure () -> String
    ) {
        #if DEBUG
        print("🐞 \(message())")
        #endif
    }

    static func database(
        _ message: @autoclosure () -> String
    ) {
        #if DEBUG
        print("💾 \(message())")
        #endif
    }
}
