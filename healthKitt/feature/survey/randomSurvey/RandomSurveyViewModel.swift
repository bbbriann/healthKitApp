//
//  RandomSurveyViewModel.swift
//  healthKitt
//
//  Created by brian on 9/23/24.
//

import SwiftUI
import Combine

final class RandomSurveyViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var surveyComplete: Bool = false
    @Published var error: Bool = false
    @Published var req: RandomSurveyReqModel = RandomSurveyReqModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: RandomSurveyInteractor
    
    init(interactor: RandomSurveyInteractor = RandomSurveyInteractor()) {
        self.interactor = interactor
    }
    
    func postData() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        isLoading = true
        interactor.postData(req: req)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.error = true
                case .finished:
                    break
                }
                self?.surveyComplete = true
            }, receiveValue: { res in
                // API 호출 결과 처리
                self.isLoading = false
                self.surveyComplete = true
            })
            .store(in: &cancellables)
    }
    
    func disabledState() -> Bool {
        if req.questionAAnswer == -1 ||
            req.questionBAnswer == -1 ||
           req.questionCAnswer == -1 {
            return true
        }
        return false
    }
}
