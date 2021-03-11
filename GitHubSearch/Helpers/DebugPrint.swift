//
//  DebugPrint.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation

fileprivate struct DebugPrintToShow: OptionSet {
    
    static let errors = DebugPrintToShow(rawValue: 1 << 0)
    static let infos = DebugPrintToShow(rawValue: 1 << 1)
    static let warnings = DebugPrintToShow(rawValue: 1 << 2)
    static let success = DebugPrintToShow(rawValue: 1 << 3)
    
    static let current: DebugPrintToShow = [.errors, .infos, .success, .warnings]
    
    let rawValue: Int8
}

fileprivate func debugPrint(_ item: Any) {
    #if DEBUG
    print("[\(Date())] \(item)")
    #endif
}

public func debugError(_ item: Any) {
    let newItems = "[❌] -> \(item)"
    if DebugPrintToShow.current.contains(.errors) {
        debugPrint(newItems)
    }
}

public func debugWarning(_ item: Any) {
    let newItems = "[⚠️] -> \(item)"
    if DebugPrintToShow.current.contains(.warnings) {
        debugPrint(newItems)
    }
}

public func debugInfo(_ item: Any) {
    let newItems = "[ℹ️] -> \(item)"
    if DebugPrintToShow.current.contains(.infos) {
        debugPrint(newItems)
    }
}

public func debugSuccess(_ item: Any) {
    let newItems = "[✅] -> \(item)"
    if DebugPrintToShow.current.contains(.success) {
        debugPrint(newItems)
    }
}
