//
//  SignUpViewModel.swift
//  healthKitt
//
//  Created by brian on 8/21/24.
//

import SwiftUI

enum SignUpStep: CaseIterable {
    case email
    case password
    case phone
    case info
    case done
    
    var next: SignUpStep? {
        if let currentIdx {
            return SignUpStep.allCases[currentIdx + 1]
        } else {
            return nil
        }
    }
    
    var currentIdx: Int? {
        let allCases = SignUpStep.allCases
        if let currentIndex = allCases.firstIndex(of: self), currentIndex < allCases.count - 1 {
            return Int(currentIndex)
        } else {
            return nil // 마지막 상태일 경우 nil 반환
        }
    }
}

final class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var pw: String = ""
    @Published var pwConfirm: String = ""
    @Published var phoneNumber: String = ""
    @Published var name: String = ""
    @Published var birth: Date = Date(timeIntervalSince1970: 953596800)
    @Published var gender: Gender? = .male
    @Published var step: SignUpStep = .email
    
    init() {
        
    }
    
    func handleStep() {
        if let next = step.next {
            step = next
        }
    }
    
    var currentStepIdx: Int {
        return (step.currentIdx ?? 0) + 1
    }
    
    func getDisabledState() -> Bool {
        switch step {
        case .email:
            return email.isEmpty
        case .password:
            return (pw.isEmpty || pwConfirm.isEmpty)
            // 비밀번호가 서로 다름.
            || pw != pwConfirm
        case .phone:
            return phoneNumber.isEmpty
        case .info:
            return name.isEmpty
        case .done:
            return false
        }
    }
    
    func getNextButtonColor() -> Color {
        return Color(hex: "#1068FD").opacity(getDisabledState() ? 0.2 : 1.0)
    }
}
