//
//  UserDefaultsExtensions.swift
//  healthKitt
//
//  Created by brian on 9/10/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let userInfo = "userInfo"
        static let surveyAgreed = "surveyAgreed"
        static let studyId = "studyId"
        static let fcmToken = "fcmToken"
        static let lastEndDate = "lastEndDate"
        static let launchSensorData = "launchSensorData"
        static let showRandomSurveyFromPush = "showRandomSurveyFromPush"
    }
    
    var showRandomSurveyFromPush: Bool? {
        get {
            return bool(forKey: Keys.showRandomSurveyFromPush)
        }
        set {
            set(newValue, forKey: Keys.showRandomSurveyFromPush)
        }
    }
    
    var launchSensorData: Bool? {
        get {
            return bool(forKey: Keys.launchSensorData)
        }
        set {
            set(newValue, forKey: Keys.launchSensorData)
        }
    }
    
    var surveyAgreed: Bool? {
        get {
            return bool(forKey: Keys.surveyAgreed)
        }
        set {
            set(newValue, forKey: Keys.surveyAgreed)
        }
    }
    
    var fcmToken: String? {
        get {
            return string(forKey: Keys.fcmToken)
        }
        set {
            set(newValue, forKey: Keys.fcmToken)
        }
    }
    
    // Access Token 저장 및 불러오기
    var accessToken: String? {
        get {
            return string(forKey: Keys.accessToken)
        }
        set {
            set(newValue, forKey: Keys.accessToken)
        }
    }
    
    // Refresh Token 저장 및 불러오기
    var refreshToken: String? {
        get {
            return string(forKey: Keys.refreshToken)
        }
        set {
            set(newValue, forKey: Keys.refreshToken)
        }
    }
    
    // Refresh Token 저장 및 불러오기
    var studyId: String? {
        get {
            return string(forKey: Keys.studyId)
        }
        set {
            set(newValue, forKey: Keys.studyId)
        }
    }
    
    // 저장된 이전 endDate를 불러오기
    var lastEndDate: Date? {
        get {
            return object(forKey: Keys.lastEndDate) as? Date
        }
        set {
            set(newValue, forKey: Keys.lastEndDate)
        }
    }
    
    // UserInfo 저장 메서드
    var userInfo: UserInfo? {
        get {
            guard let data = data(forKey: Keys.userInfo) else {
                return nil
            }
            return try? JSONDecoder().decode(UserInfo.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                set(data, forKey: Keys.userInfo)
            } else {
                removeObject(forKey: Keys.userInfo)
            }
        }
    }
    
    // 토큰 삭제 메서드
    func clearTokens() {
        removeObject(forKey: Keys.accessToken)
        removeObject(forKey: Keys.refreshToken)
        UserDefaults.standard.userInfo = nil
        UserDefaults.standard.surveyAgreed = false
    }
}

