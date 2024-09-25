//
//  RandomSurveyInteractor.swift
//  healthKitt
//
//  Created by brian on 9/23/24.
//

import Combine
import UIKit

// MARK: - RandomSurveyReqModel
struct RandomSurveyReqModel: Codable {
    var questionAAnswer, questionBAnswer, questionCAnswer: Int
//    var memo: String

    enum CodingKeys: String, CodingKey {
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
//        case memo
    }
    
    init() {
        questionAAnswer = -1
        questionBAnswer = -1
        questionCAnswer = -1
//        memo = ""
    }
}

// MARK: - RandomSurveyResModel
struct RandomSurveyResModel: Codable {
    let study, ulid: String
    let questionAAnswer, questionBAnswer, questionCAnswer: Int
//    let memo: String
    let created, modified: String

    enum CodingKeys: String, CodingKey {
        case study, ulid
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
        case created, modified
    }
}

// MARK: - RandomSurveyInteractor
class RandomSurveyInteractor {
    private let client = APIClient.shared
    
    func postData(req: RandomSurveyReqModel) -> AnyPublisher<RandomSurveyResModel, Error> {
        let jsonData = try? JSONEncoder().encode(req)
        let studyId = UserDefaults.standard.studyId ?? ""
        return client.performRequest("/studies/" + studyId + "/surveys", method: "POST", postData: jsonData)
    }
}
