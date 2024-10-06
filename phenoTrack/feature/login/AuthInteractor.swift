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
    
    func sendSensorData(req: HealthData) -> AnyPublisher<HealthResModel, Error> {
        let studyId = UserDefaults.standard.studyId ?? ""
        let jsonData = try? JSONEncoder().encode(req)
        return client.performRequest("/studies/" + studyId + "/sensors", method: "POST", postData: jsonData)
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

// MARK: - FCMReqModel
struct FCMReqModel: Codable {
    let registrationID: String

    enum CodingKeys: String, CodingKey {
        case registrationID = "registration_id"
    }
    
    init(registrationID: String) {
        self.registrationID = registrationID
    }
}

// MARK: - FCMResModel
struct FCMResModel: Codable {
    let id: Int
    let name, registrationID: String
    let deviceID: Int
    let active: Bool
    let dateCreated: String
    let cloudMessageType, applicationID: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case registrationID = "registration_id"
        case deviceID = "device_id"
        case active
        case cloudMessageType = "cloud_message_type"
        case dateCreated = "date_created"
        case applicationID = "application_id"
    }
}
