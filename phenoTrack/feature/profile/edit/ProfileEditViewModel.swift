//
//  ProfileEditViewModel.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import Combine
import SwiftUI

final class ProfileEditViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var gender: Gender? = .male
    @Published var email: String = ""
    @Published var pw: String = ""
    
    
    @Published var completeChangeProfile: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Bool = false
    @Published var showEmptyError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: ProfileEditInteractor
    
    private var user: UserInfo? {
        return UserDefaults.standard.userInfo
    }
    
    init(interactor: ProfileEditInteractor = ProfileEditInteractor()) {
        self.interactor = interactor
        name = user?.first_name ?? ""
        phoneNumber = user?.profile?.mobile_number ?? ""
        gender = user?.profile?.gender == "MALE" ? .male : .female
        email = user?.email ?? ""
        pw = "**************"
    }
    
    func isValidState() -> Bool {
        if !name.isEmpty && !phoneNumber.isEmpty && !email.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func editProfile() {
        isLoading = true
        let birth = user?.profile?.birthday ?? ""
        let profile = PostUserProfile(birthday: birth, gender: gender?.rawValue,
                                      mobile_number: phoneNumber)
        let userInfo = PostUserInfo(profile: profile, email: email, first_name: name, last_name: nil)
        let ulid = user?.ulid ?? ""
        interactor.editUserInfo(ulid: ulid, userInfo: userInfo)
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
            }, receiveValue: { userInfo in
                // API 호출 결과 처리
                UserDefaults.standard.userInfo = userInfo
                self.completeChangeProfile = true
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
}
