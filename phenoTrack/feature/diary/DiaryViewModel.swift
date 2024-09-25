//
//  DiaryViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/25/24.
//

import SwiftUI
import Combine

final class DiaryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Bool = false
    @Published var dietList: [Diet] = []
    @Published var selectedDate = Date()
    @Published var selectedDiet: Diet?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: DiaryInteractor
    
    init(interactor: DiaryInteractor = DiaryInteractor()) {
        self.interactor = interactor
    }
    
    func fetchData() {
        interactor.fetchData(date: selectedDate)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.error = true
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
}
