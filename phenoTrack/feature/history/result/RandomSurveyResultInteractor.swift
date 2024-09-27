//
//  RandomSurveyResultInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/28/24.
//

import Combine
import Foundation

// MARK: - RandomSurveyResultInteractor
class RandomSurveyResultInteractor {
    private let client = APIClient.shared
    var cursor: Int = 0
    
    func deleteSurveyData(ulid: String) -> AnyPublisher<DietListResModel, Error> {
        let studyId = UserDefaults.standard.studyId ?? ""
        return client.performRequest("/studies/" + studyId + "/surveys/" + ulid, method: "DELETE")
    }
}

