//
//  HomeInteractor.swift
//  healthKitt
//
//  Created by brian on 9/13/24.
//

import Combine
import SwiftUI

// MARK: - StudyResponse
struct Study: Decodable, Equatable {
    let ulid: String
    let title: String
    let description: String
    let isActive: Bool
    let startDate: String
    let endDate: String
    let created: String
    let modified: String
    
    // JSON의 키와 Swift 프로퍼티 이름이 다를 경우 CodingKeys 사용
    enum CodingKeys: String, CodingKey {
        case ulid
        case title
        case description
        case isActive = "is_active"
        case startDate = "start_date"
        case endDate = "end_date"
        case created
        case modified
    }
}

struct StudyListResult: Decodable {
    let study: Study
    let ulid: String
    let status: String // INVITED // JOINED
    let created: String
    let modified: String
}

struct StudyListResModel: Decodable {
    let next: String?
    let previous: String?
    let results: [StudyListResult]
}

// MARK: - LatestResModel
struct LatestResModel: Codable {
    let ulid: String
    let endAt, created, modified: String

    enum CodingKeys: String, CodingKey {
        case ulid
        case endAt = "end_at"
        case created, modified
    }
}

enum CommonError: Error {
    case noUlid
    case startEndTimeError
}

// MARK: - HomeInteractor
class HomeInteractor {
    private let client = APIClient.shared
    
    func fetchStudies() -> AnyPublisher<StudyListResModel, Error> {
        return client.performRequest("/study_users", method: "GET")
    }
    
    func fetchLatests() -> AnyPublisher<LatestResModel?, Error> {
        let studyId = UserDefaults.standard.studyId ?? ""
        return client.performRequest("/studies/" + studyId + "/survey_notifications/latest", method: "GET")
    }
}
