//
//  DiaryResultViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/28/24.
//

import SwiftUI
import Combine

final class DiaryResultViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Bool = false
    @Published var deleteComplete: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: DiaryResultInteractor
    
    init(interactor: DiaryResultInteractor = DiaryResultInteractor()) {
        self.interactor = interactor
    }
    
    func deleteData(ulid: String) {
        isLoading = true
        interactor.deleteData(ulid: ulid)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.deleteComplete = true
                    self?.isLoading = false
                    self?.error = true
                case .finished:
                    break
                }
            }, receiveValue: { res in
                // API 호출 결과 처리
                self.deleteComplete = true
                print("[TEST] res.results \(res.results)")
            })
            .store(in: &cancellables)
    }
}
