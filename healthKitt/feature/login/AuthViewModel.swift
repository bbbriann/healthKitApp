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
    @Published var email: String = "testtiostest@gmail.com"
    @Published var password: String = "xb*jo9HG!tgQxB.BqidquUJc8r2VLGj3"
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
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: AuthInteractor
    
    init(interactor: AuthInteractor = AuthInteractor()) {
        self.interactor = interactor
    }
    
    func login() {
        interactor.login(email: email, password: password)
            .sink(receiveCompletion: { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                print("[TEST] response \(response)")
                self?.accessToken = response.access
                self?.refreshToken = response.refresh
                NotificationCenter.default.post(Notification(name: .loggedIn))
            })
            .store(in: &cancellables)
    }
    
    func refreshAccessToken() {
        guard let token = refreshToken else {
            self.errorMessage = "No refresh token available"
            return
        }
        
        interactor.refreshToken(token)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.accessToken = response.access
                self?.refreshToken = response.refresh
            })
            .store(in: &cancellables)
    }
}
