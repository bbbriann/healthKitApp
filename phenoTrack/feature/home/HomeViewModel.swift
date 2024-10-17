//
//  HomeViewModel.swift
//  healthKitt
//
//  Created by brian on 8/30/24.
//

import Combine
import HealthKit
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
    @Published var homeState: HomeState = .notApproved
    @Published var isLoading: Bool = false
    @Published var study: Study?
    @Published var latestNoti: LatestResModel?
    private var cancellables = Set<AnyCancellable>()
    private let interactor: HomeInteractor
    
    init(interactor: HomeInteractor = HomeInteractor()) {
        self.interactor = interactor
    }
    
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
    
    func fetchHomeData() {
        isLoading = true
        interactor.fetchStudies()
            .flatMap { res -> AnyPublisher<LatestResModel?, Error> in
                    // 첫 번째 API 호출 결과 처리
                    print("[TEST] res \(res)")
                    self.study = res.results.first?.study
                    
                    if let result = res.results.first {
                        UserDefaults.standard.studyId = result.study.ulid
                        if result.status == "INVITED" {
                            self.homeState = .notApproved
                        } else {
                            let surveyAgreed = UserDefaults.standard.surveyAgreed ?? false
                            if surveyAgreed {
                                // surveyAgreed가 true이면 두 번째 API 호출
                                self.homeState = .noSurvey
                                return self.interactor.fetchLatests()
                            } else {
                                self.homeState = .readyToStart
                            }
                        }
                    }
                    // surveyAgreed가 false이면 빈 Publisher 반환
                    return Just(nil)  // SecondAPIResponse에 맞는 기본값
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { res in
                // API 호출 결과 처리
                if let res, let endAtDate = DateHelper.convertToDate(res.endAt, needFractionSecondes: false) {
                    self.latestNoti = res
                    print(endAtDate)
                    if endAtDate > Date() {
                        self.homeState = .survey
                        if (UserDefaults.standard.showRandomSurveyFromPush ?? false) {
                            NotificationCenter.default.post(Notification(name: .showRandomSurveyFromPush))
                            UserDefaults.standard.showRandomSurveyFromPush = false
                        }
                    } else {
                        self.homeState = .noSurvey
                    }
                }
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func setFCMToken() {
        guard let fcmToken = UserDefaults.standard.fcmToken else { return }
        interactor.updateFCMData(req: .init(registrationID: fcmToken))
            .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    print("[TEST] error \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (res) in
                print("[TEST] res \(res)")
            })
            .store(in: &cancellables)
    }
    
    var studyPeriod: String {
        guard let start = study?.startDate, let endDate = study?.endDate else {
            return ""
        }
        
        return start + " - " + endDate
    }
}
