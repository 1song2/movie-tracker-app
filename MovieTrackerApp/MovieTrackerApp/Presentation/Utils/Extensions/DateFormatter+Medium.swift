//
//  DateFormatter+Medium.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/10.
//

import Foundation

extension DateFormatter {
    static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
