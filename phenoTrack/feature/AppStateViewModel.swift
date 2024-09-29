//
//  AppStateViewModel.swift
//  healthKitt
//
//  Created by brian on 9/13/24.
//

import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isLoading: Bool = true // API 호출 상태를 추적하는 변수
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: AuthInteractor
    
    init(interactor: AuthInteractor = AuthInteractor()) {
        self.interactor = interactor
        fetchInitialData()
    }
    
    func fetchInitialData() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        if let token = UserDefaults.standard.accessToken {
            interactor.fetchUserInfo()
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching initial data: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                    self?.isLoading = false // API 호출이 끝나면 로딩 상태 해제
                }, receiveValue: { userInfo in
                    // API 호출 결과 처리
                    UserDefaults.standard.userInfo = userInfo
                    print("Fetched user info: \(userInfo)")
                })
                .store(in: &cancellables)
        } else {
            self.isLoading = false // API 호출이 끝나면 로딩 상태 해제
        }
    }
}
