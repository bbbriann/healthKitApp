//
//  ResetPWView.swift
//  healthKitt
//
//  Created by brian on 8/21/24.
//

import SwiftUI

struct ResetPWView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = ResetPWViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Spinner()
            } else {
                if viewModel.resetComplete {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "비밀번호 재설정이 완료되었습니다.",
                            message: "로그인으로 이동합니다.",
                            onlyConfirm: true,
                            confirmTitle: "확인",
                            onCancel: { },
                            onConfirm: {
                                presentationMode.wrappedValue.dismiss()
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
                            title: "비밀번호 재설정에 실패하였습니다.",
                            message: "이메일과 비밀번호를 재확인하세요.",
                            onlyConfirm: true,
                            confirmTitle: "확인",
                            onCancel: { },
                            onConfirm: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
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
                    .background(Color(hex: "#1068FD"))
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("비밀번호 재설정")
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
                if viewModel.step == .emailAndPhone {
                    Text("비밀번호 재설정을 위해 등록하신 전화번호와 이메일을 입력해주세요.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .frame(width: 345, alignment: .topLeading)
                    VStack(spacing: 12) {
                        CommonInputView(text: $viewModel.phone, image: "IcPhone",
                                        placeholder: "휴대폰 번호 입력", keyboardType: .phonePad)
                        CommonInputView(text: $viewModel.email, image: "IcEmail",
                                        placeholder: "이메일 입력", keyboardType: .emailAddress)
                    }
                } else {
                    Text("새롭게 사용할 비밀번호를\n입력해주세요.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .frame(width: 345, alignment: .topLeading)
                    VStack(spacing: 12) {
                        CommonInputView(text: $viewModel.pw, image: "IcPW",
                                        placeholder: "비밀번호 입력", isSecure: true)
                        CommonInputView(text: $viewModel.pwConfirm, image: "IcPW",
                                        placeholder: "비밀번호를 다시 확인하세요", isSecure: true)
                    }
                }
                
                Spacer()
                Button {
                    viewModel.handleStep()
                } label: {
                    CommonSelectButton(title: viewModel.step == .emailAndPhone ? "비밀번호 재설정하기" : "확인",
                                       titleColor: .white,
                                       bgColor: nextButtonBGColor)
                    .padding(.bottom, safeAreaInsets.bottom)
                }
                .disabled(viewModel.getDisabledState())
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
        return viewModel.getNextButtonColor()
    }
}
