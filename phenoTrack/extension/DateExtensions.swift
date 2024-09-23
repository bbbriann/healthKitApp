//
//  DateExtensions.swift
//  healthKitt
//
//  Created by brian on 8/25/24.
//

import Foundation

extension Date {
    func toYYYYMMDDString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toYYYYMMDDKRString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        return dateFormatter.string(from: self)
    }
}
