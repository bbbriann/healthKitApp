//
//  ProfileEditInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import Combine
import UIKit

// MARK: - ProfileEditInteractor
class ProfileEditInteractor {
    private let client = APIClient.shared
    
    func editUserInfo(ulid: String, userInfo: PostUserInfo) -> AnyPublisher<UserInfo, Error> {
        let jsonData = try? JSONEncoder().encode(userInfo)
        return client.performRequest("/users/" + ulid, method: "PUT", postData: jsonData)
    }
}
