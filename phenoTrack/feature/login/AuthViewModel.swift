//
//  AuthViewModel.swift
//  healthKitt
//
//  Created by brian on 9/10/24.
//

import Combine
import SwiftUI

// MARK: - AuthViewModel
class AuthViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password: String = ""
    @Published var email: String = "testtiostest@gmail.com"
    @Published var password: String = "xb*jo9HG!tgQxB.BqidquUJc8r2VLGj3"
//    @Published var email: String = "ios@ios.com"
//    @Published var password: String = "qwer1234!"
    @Published var accessToken: String? {
        didSet {
            UserDefaults.standard.accessToken = accessToken
        }
    }
    @Published var refreshToken: String? {
        didSet {
            UserDefaults.standard.refreshToken = refreshToken
        }
    }
    @Published var userInfo: UserInfo? {
        didSet {
            UserDefaults.standard.userInfo = userInfo
        }
    }
    
    @Published var showError: Bool = false
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: AuthInteractor
    
    init(interactor: AuthInteractor = AuthInteractor()) {
        self.interactor = interactor
    }
    
    func login() {
        isLoading = true
        interactor.login(email: email, password: password)
            .flatMap({ response in
                self.accessToken = response.access
                self.refreshToken = response.refresh
                return self.interactor.fetchUserInfo()
            })
            .sink(receiveCompletion: { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.isLoading = false
                    self?.showError = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                print("[TEST] response \(response)")
                self?.userInfo = response
                self?.isLoading = false
                NotificationCenter.default.post(Notification(name: .loggedIn))
            })
            .store(in: &cancellables)
    }
    
    func refreshAccessToken() {
        guard let token = refreshToken else {
            self.showError = true
            return
        }
        
        interactor.refreshToken(token)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showError = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.accessToken = response.access
                self?.refreshToken = response.refresh
            })
            .store(in: &cancellables)
    }
    
    func fetchUserInfo() {
        interactor.fetchUserInfo()
            .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    self?.showError = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (userInfo: UserInfo) in
                print("[TEST] userInfo \(userInfo)")
                self?.userInfo = userInfo
            })
            .store(in: &cancellables)
    }
}
