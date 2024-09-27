//
//  DiaryResultInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/28/24.
//

import Combine
import Foundation

// MARK: - DiaryResultInteractor
class DiaryResultInteractor {
    private let client = APIClient.shared
    var cursor: Int = 0
    
    func deleteData(ulid: String) -> AnyPublisher<DietListResModel, Error> {
        let studyId = UserDefaults.standard.studyId ?? ""
        return client.performRequest("/studies/" + studyId + "/diets/" + ulid, method: "DELETE")
    }
}
