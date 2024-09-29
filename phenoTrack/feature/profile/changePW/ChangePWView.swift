//
//  ChangePWView.swift
//  phenoTrack
//
//  Created by brian on 9/30/24.
//

import SwiftUI

struct ChangePWView: View {
    @Binding var path: [ProfileViewStack]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = ChangePWViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    HStack(alignment: .center, spacing: 16) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
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
                if viewModel.showError {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "비밀번호 변경 오류",
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
        .onChange(of: viewModel.completeChangePW) { oldValue, newValue in
            guard viewModel.completeChangePW else { return }
            presentationMode.wrappedValue.dismiss()
        }
        //        .padding(.horizontal, 24)
        /// content...
    }
    
    var contentView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                CommonInputView(text: $viewModel.pw, image: "IcPW",
                                placeholder: "현재 비밀번호를 입력하세요",
                                isSecure: true, needNoFocus: true)
                CommonInputView(text: $viewModel.newPw, image: "IcPW",
                                placeholder: "비밀번호 입력", isSecure: true)
                CommonInputView(text: $viewModel.newPwConfirm, image: "IcPW",
                                placeholder: "비밀번호를 다시 확인하세요", isSecure: true)
                Spacer()
                
                Button {
                    viewModel.changePW()
                } label: {
                    CommonSelectButton(title: "비밀번호 변경하기", titleColor: .white,
                                       bgColor: buttonBGColor,
                                       cornerRadius: 16)
                }
                .disabled(!viewModel.isValidState())
                .padding(.bottom, safeAreaInsets.bottom)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
    
    var buttonBGColor: Color {
        return Color(hex: "#1068FD").opacity(!viewModel.isValidState() ? 0.2 : 1.0)
    }
}
