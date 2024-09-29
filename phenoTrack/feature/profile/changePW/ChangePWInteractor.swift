//
//  ChangePWInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import Combine
import SwiftUI

// MARK: - ChangePWReqModel
struct ChangePWReqModel: Codable {
    let currentPassword, newPassword: String

    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case newPassword = "new_password"
    }
}

// MARK: - ChangePWInteractor
class ChangePWInteractor {
    private let client = APIClient.shared
    
    func changePW(req: ChangePWReqModel) -> AnyPublisher<ResetPWResModel, Error> {
        let jsonData = try? JSONEncoder().encode(req)
        return client.performRequest("/users/update_password", method: "PUT", postData: jsonData)
    }
}
