//
//  HomeViewModel.swift
//  healthKitt
//
//  Created by brian on 8/30/24.
//

import SwiftUI

enum HomeState: String, CaseIterable, Identifiable {
    var id: String { self.rawValue } 
    case notApproved
    case readyToStart
    case noSurvey
    case survey
    case surveyFinish
}

final class HomeViewModel: ObservableObject {
    @Published var homeState: HomeState = .survey
    init() { }
    
    var bottomPadding: CGFloat {
        switch homeState {
        case .notApproved:
            return 32
        case .readyToStart:
            return 20
        case .noSurvey:
            return 32
        case .survey:
            return 15
        case .surveyFinish:
            return 20
        }
    }
    
    var showInfoButton: Bool {
        switch homeState {
        case .notApproved:
            return true
        case .readyToStart:
            return true
        case .noSurvey:
            return false
        case .survey:
            return true
        case .surveyFinish:
            return true
        }
    }
    
    var infoTitle: String {
        switch homeState {
        case .notApproved:
            return "승인 대기중"
        case .readyToStart:
            return "승인됨"
        case .noSurvey:
            return ""
        case .survey:
            return "작성 방법"
        case .surveyFinish:
            return "이용 종료"
        }
    }
}
