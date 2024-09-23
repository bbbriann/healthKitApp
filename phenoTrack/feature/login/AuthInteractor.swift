//
//  AuthInteractor.swift
//  healthKitt
//
//  Created by brian on 9/10/24.
//

import Combine
import SwiftUI

// MARK: - AuthResponse
struct AuthResponse: Decodable {
    let access: String
    let refresh: String
}

// MARK: - AuthInteractor
class AuthInteractor {
    private let client = APIClient.shared
    
    func login(email: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        let parameters = ["email": email, "password": password]
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return client.performRequest("/auth/token", method: "POST", postData: data)
    }
    
    func refreshToken(_ refreshToken: String) -> AnyPublisher<AuthResponse, Error> {
        let parameters = ["refreshToken": refreshToken]
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return client.performRequest("/auth/refresh", method: "POST", postData: data)
    }
    
    func fetchUserInfo() -> AnyPublisher<UserInfo, Error> {
        return client.performRequest("/users/me", method: "GET")
    }
    
    func postUserInfo(userInfo: PostUserInfo) -> AnyPublisher<UserInfo, Error> {
        let jsonData = try? JSONEncoder().encode(userInfo)
        return client.performRequest("/users", method: "POST", postData: jsonData)
    }
}


struct UserProfile: Codable {
    var ulid: String?
    var birthday: String?
    var gender: String?
    var mobile_number: String?
    var created: String?
    var modified: String?
}

// 전체 사용자 정보를 나타내는 구조체
struct UserInfo: Codable {
    var profile: UserProfile?
    var ulid: String?
    var email: String?
    var first_name: String?
    var last_name: String?
    var created: String?
    var modified: String?
}


struct PostUserInfo: Codable {
    var profile: PostUserProfile?
    var email: String?
    var first_name: String?
    var last_name: String?
}


struct PostUserProfile: Codable {
    var birthday: String?
    var gender: String?
    var mobile_number: String?
}
