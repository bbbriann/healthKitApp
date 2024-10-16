//
//  LoginView.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
//    @State private var email: String = ""
//    @State private var pw: String = ""
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Spinner()
                    .background(Color(hex: "#1068FD"))
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea(edges: .bottom)
                    .navigationBarTitle("")
                    .navigationBarBackButtonHidden(true)
            } else {
                if viewModel.showError {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "로그인 오류",
                            message: "정보를 찾을 수 없습니다.\n이메일과 비밀번호를 확인하세요.",
                            onlyConfirm: true,
                            onCancel: { },
                            onConfirm: {
                                viewModel.showError.toggle()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                    .navigationBarTitle("로그인")
                    .navigationBarBackButtonHidden(true)
//                    .toolbar {
//                        ToolbarItemGroup(placement: .topBarLeading) {
//                            backButton
//                        }
//                    }
                } else {
                    VStack {
                        Spacer(minLength: 61)
                        ZStack {
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .cornerRadius(24)
                                .rotationEffect(Angle(degrees: -4))
                            contentView
                                .cornerRadius(24)
                        }
                    }
                }
            }
        }
        .background(Color(hex: "#1068FD"))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("로그인")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                backButton
            }
        }
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackButtonView()
        }
    }
    
    var contentView: some View {
        ZStack {
            VStack {
                Text("PhoneTrack에 오신 것을 환영합니다.\n로그인해주세요")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(width: 345, alignment: .topLeading)
                VStack(spacing: 12) {
                    CommonInputView(text: $viewModel.email, image: "IcEmail", 
                                    placeholder: "이메일 입력", keyboardType: .emailAddress)
                    CommonInputView(text: $viewModel.password, image: "IcPW",
                                    placeholder: "비밀번호 입력", isSecure: true)
                }
                
                Spacer()
                Button {
                    viewModel.login()
                } label: {
                    CommonSelectButton(title: "로그인",
                                       titleColor: .white,
                                       bgColor: nextButtonBGColor)
                    .disabled(disabledState)
                    .padding(.bottom, safeAreaInsets.bottom)
                }
            }
            .padding(.horizontal, 24)
            .background(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .background(.white)
        .cornerRadius(24)
    }
    
    var nextButtonBGColor: Color {
        return Color(hex: "#1068FD").opacity(viewModel.email.isEmpty ? 0.2 : 1.0)
    }
    
    private var disabledState: Bool {
        viewModel.email.isEmpty || viewModel.password.isEmpty
    }
}
