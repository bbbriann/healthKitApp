//
//  DiaryRandomSurveyInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/24/24.
//

import Combine
import UIKit


// MARK: - DietsRandomSurveyReqModel
struct DietsRandomSurveyReqModel: Codable {
    var whenToEat: String?
    var questionAAnswer, questionBAnswer, questionCAnswer, questionDAnswer: Int
    var questionEAnswer: Int
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case whenToEat = "when_to_eat"
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
        case questionDAnswer = "question_d_answer"
        case questionEAnswer = "question_e_answer"
        case memo
    }
    
    init() {
        questionAAnswer = -1
        questionBAnswer = -1
        questionCAnswer = -1
        questionDAnswer = -1
        questionEAnswer = -1
        memo = ""
    }
}


// MARK: - DietsRandomSurveyResModel
struct DietsRandomSurveyResModel: Codable {
    let study, ulid: String
    let whenToEat: Date
    let questionAAnswer, questionBAnswer, questionCAnswer, questionDAnswer: Int
    let questionEAnswer: Int
    let memo: String
    let created, modified: Date

    enum CodingKeys: String, CodingKey {
        case study, ulid
        case whenToEat = "when_to_eat"
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
        case questionDAnswer = "question_d_answer"
        case questionEAnswer = "question_e_answer"
        case memo, created, modified
    }
}



// MARK: - RandomSurveyInteractor
class DiaryRandomSurveyInteractor {
    private let client = APIClient.shared
    
    func postData(req: DietsRandomSurveyReqModel) -> AnyPublisher<DietsRandomSurveyResModel, Error> {
        let jsonData = try? JSONEncoder().encode(req)
        let studyId = UserDefaults.standard.studyId ?? ""
        return client.performRequest("/studies/" + studyId + "/diets", method: "POST", postData: jsonData)
    }
}

