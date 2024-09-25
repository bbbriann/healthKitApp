//
//  HistoryInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/26/24.
//

import Combine
import UIKit

struct RandomSurveyListResModel: Decodable {
    let next: String?
    let previous: String?
    let results: [RandomSurvey]
}

// MARK: - HistoryInteractor
class HistoryInteractor {
    private let client = APIClient.shared
    var cursor: Int = 0
    func fetchDietData(date: Date) -> AnyPublisher<DietListResModel, Error> {
        guard let (start, end) = date.toISO8601Strings() else {
            return Fail(error: CommonError.startEndTimeError)
                .eraseToAnyPublisher()
        }
        let studyId = UserDefaults.standard.studyId ?? ""
        let queryParams: [String: String] = ["created__gte": start, "created__lte": end]
        return client.performRequest("/studies/" + studyId + "/diets", method: "GET",queryParams: queryParams)
    }
    
    func fetchRandomSurveyData(date: Date) -> AnyPublisher<RandomSurveyListResModel, Error> {
        guard let (start, end) = date.toISO8601Strings() else {
            return Fail(error: CommonError.startEndTimeError)
                .eraseToAnyPublisher()
        }
        let studyId = UserDefaults.standard.studyId ?? ""
        let queryParams: [String: String] = ["created__gte": start, "created__lte": end]
        return client.performRequest("/studies/" + studyId + "/surveys", method: "GET",queryParams: queryParams)
    }
}
