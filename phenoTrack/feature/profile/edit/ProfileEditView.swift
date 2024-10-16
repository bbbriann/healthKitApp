//
//  ProfileEditView.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import SwiftUI

struct ProfileEditView: View {
    @Binding var path: [ProfileViewStack]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = ProfileEditViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    HStack(alignment: .center, spacing: 16) {
                        Button {
                            if viewModel.isValidState() {
                                viewModel.showAlert.toggle()
                            } else {
                                viewModel.showEmptyError.toggle()
                            }
                        } label: {
                            Image("IcBackBtnBlue")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        // Title/20px/Bold
                        Text("내 정보 관리")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .padding(.horizontal, 24)
            if viewModel.isLoading {
                Spinner()
            } else {
                if viewModel.showAlert {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "이전 화면으로 돌아 갈 시 현재 상태로 저장이 됩니다.",
                            message: "저장하시겠습니까?",
                            confirmTitle: "확인",
                            onCancel: { 
                                NotificationCenter.default.post(Notification(name: .showTabBar))
                                presentationMode.wrappedValue.dismiss()
                            },
                            onConfirm: {
                                viewModel.editProfile()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                } else if viewModel.showEmptyError {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "프로필 내용을 채워주세요.",
                            message: "비어져있는 내용이 있습니다.",
                            onlyConfirm: true,
                            confirmTitle: "확인",
                            onCancel: { },
                            onConfirm: {
                                viewModel.showEmptyError.toggle()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                } else if viewModel.showError {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "프로필 변경 오류",
                            message: "내용을 다시 확인해주세요.",
                            onlyConfirm: true,
                            confirmTitle: "확인",
                            onCancel: { },
                            onConfirm: {
                                viewModel.showError.toggle()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                } else {
                    contentView
                        .cornerRadius(24)
                    Spacer()
                }
            }
        }
        .background(.white)
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
        .onChange(of: viewModel.completeChangeProfile) { oldValue, newValue in
            guard viewModel.completeChangeProfile else { return }
            NotificationCenter.default.post(Notification(name: .profileViewRefresh))
            NotificationCenter.default.post(Notification(name: .showTabBar))
            presentationMode.wrappedValue.dismiss()
        }
        //        .padding(.horizontal, 24)
        /// content...
    }
    
    var contentView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                CommonInputView(text: $viewModel.name, image: "IcProfile",
                                placeholder: "이름(실명)", needNoFocus: true)
                if viewModel.regexError == .nameLength {
                    HStack {
                        Image("IcInvalid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(viewModel.regexError.desc)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Color(hex: "#DA072D"))
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                
                CommonInputView(text: $viewModel.phoneNumber, image: "IcPhone",
                                placeholder: "전화번호를 입력하세요", keyboardType: .phonePad, needNoFocus: true)
                
                if viewModel.regexError == .phoneValid {
                    HStack {
                        Image("IcInvalid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(viewModel.regexError.desc)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Color(hex: "#DA072D"))
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                
                
                CommonInputView(text: .constant("성별"), image: "IcGender",
                                specificType: .birth, gender: $viewModel.gender, 
                                needNoFocus: true)
                CommonInputView(text: $viewModel.email, image: "IcEmail",
                                placeholder: "이메일 입력", keyboardType: .emailAddress, needNoFocus: true)
                
                if viewModel.regexError == .emailRegex {
                    HStack {
                        Image("IcInvalid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(viewModel.regexError.desc)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Color(hex: "#DA072D"))
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                
                Button {
                    path.append(.changePassword)
                } label: {
                    CommonInputView(text: $viewModel.pw, image: "IcPW",
                                    isSecure: true, specificType: .pwEdit, needNoFocus: true)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onChange(of: viewModel.email) { oldValue, newValue in
            viewModel.checkEmailValid(newValue)
        }
        .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
            viewModel.checkPhoneNumValid()
        }
        .onChange(of: viewModel.name) { oldValue, newValue in
            viewModel.checkNameLength()
        }
    }
}
