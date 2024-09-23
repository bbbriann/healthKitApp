//
//  FindIdInteractor.swift
//  healthKitt
//
//  Created by brian on 9/22/24.
//

import Combine
import UIKit

struct FindIdReqModel: Codable {
    var mobile_number: String?
}

struct FindIdResModel: Codable {
    var email: String?
}

// MARK: - FindIdInteractor
class FindIdInteractor {
    private let client = APIClient.shared
    
    func findId(req: FindIdReqModel) -> AnyPublisher<FindIdResModel, Error> {
        let jsonData = try? JSONEncoder().encode(req)
        return client.performRequest("/users/find_email", method: "POST", postData: jsonData)
    }
}
