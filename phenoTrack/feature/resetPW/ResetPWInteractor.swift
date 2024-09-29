//
//  ResetPWInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/29/24.
//

import Combine
import UIKit

struct ResetPWResModel: Codable {
    var mobile_number: String?
}

// MARK: - ResetPWReqModel
struct ResetPWReqModel: Codable {
    let mobileNumber, email, newPassword: String

    enum CodingKeys: String, CodingKey {
        case mobileNumber = "mobile_number"
        case email
        case newPassword = "new_password"
    }
}

// MARK: - ResetPWInteractor
class ResetPWInteractor {
    private let client = APIClient.shared
    
    func resetPW(req: ResetPWReqModel) -> AnyPublisher<ResetPWResModel, Error> {
        let jsonData = try? JSONEncoder().encode(req)
        return client.performRequest("/users/reset_password", method: "POST", postData: jsonData)
    }
}
