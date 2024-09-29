//
//  ResetPWViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/29/24.
//

import SwiftUI
import Combine

enum ResetPWStep: CaseIterable {
    case emailAndPhone
    case password
    case done
    
    var next: ResetPWStep? {
        if let currentIdx {
            return ResetPWStep.allCases[currentIdx + 1]
        } else {
            return nil
        }
    }
    
    var currentIdx: Int? {
        let allCases = ResetPWStep.allCases
        if let currentIndex = allCases.firstIndex(of: self), currentIndex < allCases.count - 1 {
            return Int(currentIndex)
        } else {
            return nil // 마지막 상태일 경우 nil 반환
        }
    }
}

final class ResetPWViewModel: ObservableObject {
    @Published var isLoading: Bool = false // API 호출 상태를 추적하는 변수
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var pw: String = ""
    @Published var pwConfirm: String = ""
    @Published var resetComplete: Bool = false
    @Published var showError: Bool = false
    
    @Published var step: ResetPWStep = .emailAndPhone
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: ResetPWInteractor
    
    init(interactor: ResetPWInteractor = ResetPWInteractor()) {
        self.interactor = interactor
    }
    
    func resetPW() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        isLoading = true
        interactor.resetPW(req: .init(mobileNumber: phone, email: email, newPassword: pw))
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
                self.resetComplete = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func getDisabledState() -> Bool {
        switch step {
        case .emailAndPhone:
            return (email.isEmpty || phone.isEmpty)
        case .password:
            return (pw.isEmpty || pwConfirm.isEmpty) && (pw != pwConfirm)
            // 비밀번호가 서로 다름.
        case .done:
            return false
        }
    }
    
    func handleStep() {
        if let next = step.next {
            if next == .done {
                resetPW()
            }
            step = next
        }
    }
    
    func handlePWInfo() {
        resetPW()
    }
    
    func getNextButtonColor() -> Color {
        return Color(hex: "#1068FD").opacity(getDisabledState() ? 0.2 : 1.0)
    }
}
