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
    
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // "HH"는 24시간제, "mm"는 분
        return dateFormatter.string(from: self)
    }
    
    // 특정 날짜의 시작 시간 (00:00)과 끝 시간 (23:59)을 ISO 8601 문자열로 반환하는 함수
    func toISO8601Strings() -> (startOfDay: String, endOfDay: String)? {
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 시간대 설정
        
        // 해당 날짜의 시작 시간(00:00)
        guard let startOfDay = calendar.startOfDay(for: self) as Date?,
              let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) else {
            return nil
        }
        
        // ISO 8601 형식의 문자열로 변환
        let startOfDayString = formatter.string(from: startOfDay)
        let endOfDayString = formatter.string(from: endOfDay)
        
        return (startOfDayString, endOfDayString)
    }
}
