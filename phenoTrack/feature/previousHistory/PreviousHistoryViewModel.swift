//
//  PreviousHistoryViewModel.swift
//  phenoTrack
//
//  Created by brian on 10/10/24.
//

import Combine
import SwiftUI

final class PreviousHistoryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var dietList: [Diet] = []
    @Published var selectedDate = Date()
    @Published var selectedDiet: Diet?
    @Published var selectedRandomSurvey: RandomSurvey?
    
    @Published var randomSurveyList: [RandomSurvey] = []
    
    private let interactor: HistoryInteractor
    
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: HistoryInteractor = HistoryInteractor()) {
        self.interactor = interactor
    }
    
    func fetchDietsData() {
        interactor.fetchDietData(date: selectedDate)
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
                print("[TEST] res.results \(res.results)")
                self.dietList = res.results
            })
            .store(in: &cancellables)
    }
    
    func fetchRandomSurveyListData() {
        interactor.fetchRandomSurveyData(date: selectedDate)
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
                print("[TEST] res.results \(res.results)")
                self.randomSurveyList = res.results
            })
            .store(in: &cancellables)
    }
    
    func reportedCount(index: Int) -> Int {
        if index == 0 {
            return randomSurveyList.count
        } else {
            return dietList.count
        }
    }
}
