//
//  ChangePWViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import Combine
import SwiftUI

final class ChangePWViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var pw: String = ""
    
    @Published var newPw: String = ""
    @Published var newPwConfirm: String = ""
    
    
    @Published var completeChangePW: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Bool = false
    @Published var showEmptyError: Bool = false
    
    @Published var regexError: SignUpError = .none
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: ChangePWInteractor
    
    init(interactor: ChangePWInteractor = ChangePWInteractor()) {
        self.interactor = interactor
    }
    
    func isValidState() -> Bool {
        if !pw.isEmpty && !newPw.isEmpty &&
            !newPwConfirm.isEmpty {
            if regexError == .pwLength8 || regexError == .pwNotSame {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    func checkPWLength() {
        let isValid = newPw.count >= 8
        if !isValid {
            regexError = .pwLength8
        } else {
            regexError = .none
        }
    }
    
    func checkPWNotSame() {
        let isValid = (newPw == newPwConfirm)
        if !isValid {
            regexError = .pwNotSame
        } else {
            regexError = .none
        }
    }
    
    func changePW() {
        isLoading = true
        interactor.changePW(req: .init(currentPassword: pw, newPassword: newPw))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.showError = true
                case .finished:
                    break
                }
                self?.isLoading = false // API 호출이 끝나면 로딩 상태 해제
            }, receiveValue: { emailRes in
                // API 호출 결과 처리
                self.completeChangePW = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
}
