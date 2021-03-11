//
//  Date+Formatting.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//
import Foundation
extension Date {
    var iso8601WithFractionalSeconds: String {
        DateFormatter.iso8601WithFractionalSeconds.string(from: self)
    }
}
extension DateFormatter {
    fileprivate static let iso8601WithFractionalSeconds = ISO8601DateFormatter([
        .withInternetDateTime,
        .withFractionalSeconds,
    ])
}

extension ISO8601DateFormatter {
    fileprivate convenience init(
        _ formatOptions: Options,
        timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
