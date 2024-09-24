//
//  DiaryInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/25/24.
//

import Combine
import UIKit

// MARK: - Diet
struct Diet: Codable {
    let ulid: String
    let whenToEat: Date
    let questionAAnswer, questionBAnswer, questionCAnswer, questionDAnswer: Int
    let questionEAnswer: Int
    let memo: String
    let created, modified: Date

    enum CodingKeys: String, CodingKey {
        case ulid
        case whenToEat = "when_to_eat"
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
        case questionDAnswer = "question_d_answer"
        case questionEAnswer = "question_e_answer"
        case memo, created, modified
    }
}

struct DietListResModel: Decodable {
    let next: String?
    let previous: String?
    let results: [Diet]
}

// MARK: - DiaryInteractor
class DiaryInteractor {
    private let client = APIClient.shared
    var cursor: Int = 0
    func fetchData(date: Date) -> AnyPublisher<DietListResModel, Error> {
        guard let (start, end) = date.toISO8601Strings() else {
            return Fail(error: CommonError.startEndTimeError)
                .eraseToAnyPublisher()
        }
        let studyId = UserDefaults.standard.studyId ?? ""
        let queryParams: [String: String] = ["created__gte": start, "created__lte": end]
        return client.performRequest("/studies/" + studyId + "/diets", method: "GET",queryParams: queryParams)
    }
}
