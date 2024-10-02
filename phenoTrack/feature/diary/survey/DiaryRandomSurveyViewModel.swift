//
//  DiaryRandomSurveyViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/24/24.
//

import SwiftUI
import Combine

final class DiaryRandomSurveyViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var surveyComplete: Bool = false
    @Published var error: Bool = false
    @Published var req: DietsRandomSurveyReqModel = DietsRandomSurveyReqModel()
    
    @Published var modifyId: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: DiaryRandomSurveyInteractor
    
    init(interactor: DiaryRandomSurveyInteractor = DiaryRandomSurveyInteractor()) {
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
    
    func modifyData() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        isLoading = true
        interactor.modifyData(req: req, ulid: modifyId)
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
           req.questionDAnswer == -1 {
            return true
        }
        return false
    }
}
