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
        return client.performRequest("/auth/token", method: "POST", parameters: parameters)
    }
    
    func refreshToken(_ refreshToken: String) -> AnyPublisher<AuthResponse, Error> {
        let parameters = ["refreshToken": refreshToken]
        return client.performRequest("/auth/refresh", method: "POST", parameters: parameters)
    }
}
