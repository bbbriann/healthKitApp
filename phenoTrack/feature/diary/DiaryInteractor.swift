//
//  DiaryInteractor.swift
//  phenoTrack
//
//  Created by brian on 9/25/24.
//

import Combine
import UIKit

// MARK: - Diet
struct Diet: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    let ulid: String
    let whenToEat: String
    let questionAAnswer, questionBAnswer, questionCAnswer, questionDAnswer: Int
    let questionEAnswer: Int
    let memo: String
    let created, modified: String

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
    
    func getAnswerText(index: Int) -> String {
        switch index {
        case 0, 1, 2, 3:
            var answer = 0
            if index == 0 {
                answer = self.questionAAnswer
            } else if index == 1 {
                answer = self.questionBAnswer
            } else if index == 2 {
                answer = self.questionCAnswer
            } else if index == 3 {
                answer = self.questionDAnswer
            }
            
            if answer == 0 {
                return "전혀 아니다"
            } else if answer == 1 {
                return "아니다"
            } else if answer == 2 {
                return "보통이다"
            } else if answer == 3 {
                return "그렇다"
            } else {
                return "매우 그렇다"
            }
        case 4:
            let answer = questionEAnswer
            if answer == 0 {
                return "아니다"
            } else if answer == 1 {
                return "모르겠다"
            } else {
                return "그렇다"
            }
        case 5:
            return memo
        default:
            return ""
        }
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
