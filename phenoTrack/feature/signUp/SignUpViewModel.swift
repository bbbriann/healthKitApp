//
//  SignUpViewModel.swift
//  healthKitt
//
//  Created by brian on 8/21/24.
//

import Combine
import SwiftUI

enum SignUpError: Error {
    // 유효하지 않은 이메일 입니다. 형식을 확인해주세요.
    case emailRegex
    // 비밀번호는 최소 8자 이상이 필요합니다.
    case pwLength8
    // 비밀번호가 일치하지 않습니다.
    case pwNotSame
    // 010xxxxxxxx 형태에 맞게 번호를 입력해주세요.
    case phoneValid
    // 이름은 최소 2글자 이상 입력해주세요.
    case nameLength
    case none
    
    var desc: String {
        switch self {
        case .emailRegex:
            return "유효하지 않은 이메일 입니다. 형식을 확인해주세요."
        case .pwLength8:
            return "비밀번호는 최소 8자 이상이 필요합니다."
        case .pwNotSame:
            return "비밀번호가 일치하지 않습니다."
        case .phoneValid:
            return "010xxxxxxxx 형태에 맞게 번호를 입력해주세요."
        case .nameLength:
            return "이름은 최소 2글자 이상 입력해주세요."
        case .none:
            return ""
        }
    }
}

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
    @Published var showError: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var signUpFinished: Bool = false
    @Published var signupError: SignUpError = .none
    private let interactor: AuthInteractor
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: AuthInteractor = AuthInteractor()) {
        self.interactor = interactor
    }
    
    func handleStep() {
        if let next = step.next {
            if next == .done {
                submitUserInfo()
                return
            }
            step = next
        }
    }
    
    var currentStepIdx: Int {
        return (step.currentIdx ?? 0) + 1
    }
    
    func getDisabledState() -> Bool {
        switch step {
        case .email:
            return email.isEmpty || signupError == .emailRegex
        case .password:
            return (pw.isEmpty || pwConfirm.isEmpty) || (signupError == .pwNotSame || signupError == .pwLength8)
        case .phone:
            return phoneNumber.isEmpty || signupError == .phoneValid
        case .info:
            return name.isEmpty || signupError == .nameLength
        case .done:
            return false
        }
    }
    
    func getNextButtonColor() -> Color {
        return Color(hex: "#1068FD").opacity(getDisabledState() ? 0.2 : 1.0)
    }
    
    func checkEmailValid(_ email: String) {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailTest.evaluate(with: email)
        if !isValid {
            signupError = .emailRegex
        } else {
            signupError = .none
        }
    }
    
    func checkPWLength() {
        let isValid = pw.count >= 8
        if !isValid {
            signupError = .pwLength8
        } else {
            signupError = .none
        }
    }
    
    func checkPWNotSame() {
        let isValid = (pw == pwConfirm)
        if !isValid {
            signupError = .pwNotSame
        } else {
            signupError = .none
        }
    }
    
    func checkPhoneNumValid() {
        let phoneRegex = "^010\\d{8}$"  // 010으로 시작하고 뒤에 숫자 8자리
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)  // 정규식 사용
        let isValid = phoneTest.evaluate(with: phoneNumber)
        if !isValid {
            signupError = .phoneValid
        } else {
            signupError = .none
        }
    }
    
    func checkNameLength() {
        let isValid = name.count >= 2
        if !isValid {
            signupError = .nameLength
        } else {
            signupError = .none
        }
    }
    
    func submitUserInfo() {
        isLoading = true
        signUpFinished = false
        let profile = PostUserProfile(birthday: birth.toYYYYMMDDString(), gender: gender?.rawValue, mobile_number: phoneNumber)
        let userInfo = PostUserInfo(profile: profile, password: pw, email: email, first_name: name, last_name: nil)
        interactor.postUserInfo(userInfo: userInfo)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial data: \(error.localizedDescription)")
                    self?.isLoading = false
                    self?.showError = true
                case .finished:
                    self?.isLoading = false
                    break
                }
            }, receiveValue: { userInfo in
                // API 호출 결과 처리
                print("Fetched user info: \(userInfo)")
                self.signUpFinished = true
            })
            .store(in: &cancellables)
    }
}
