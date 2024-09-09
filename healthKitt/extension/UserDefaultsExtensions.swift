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
    
    // 토큰 삭제 메서드
    func clearTokens() {
        removeObject(forKey: Keys.accessToken)
        removeObject(forKey: Keys.refreshToken)
    }
}

