//
//  FindIdViewModel.swift
//  healthKitt
//
//  Created by brian on 9/22/24.
//

import SwiftUI
import Combine

final class FindIdViewModel: ObservableObject {
    @Published var isLoading: Bool = false // API 호출 상태를 추적하는 변수
    @Published var foundEmail: String = ""
    @Published var phone: String = ""
    @Published var emptyResult: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: FindIdInteractor
    
    init(interactor: FindIdInteractor = FindIdInteractor()) {
        self.interactor = interactor
    }
    
    func searchId() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        isLoading = true
        interactor.findId(req: .init(mobile_number: phone))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.emptyResult = true
                case .finished:
                    break
                }
                self?.isLoading = false // API 호출이 끝나면 로딩 상태 해제
            }, receiveValue: { emailRes in
                // API 호출 결과 처리
                self.isLoading = false
                let email = emailRes.email ?? ""
                self.foundEmail = email
            })
            .store(in: &cancellables)
    }
}
