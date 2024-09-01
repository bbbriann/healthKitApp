//
//  IntExtensions.swift
//  healthKitt
//
//  Created by brian on 9/1/24.
//

import Foundation

extension Int {
    func toTwoDigits() -> String {
        return String(format: "%02d", self)
    }
}
