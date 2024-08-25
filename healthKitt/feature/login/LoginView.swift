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
    @State private var email: String = ""
    @State private var pw: String = ""
    
    var body: some View {
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
                    CommonInputView(text: $email, image: "IcEmail", placeholder: "이메일 입력")
                    CommonInputView(text: $pw, image: "IcPW",
                                    placeholder: "비밀번호 입력", isSecure: true)
                }
                
                Spacer()
                Button {
                    NotificationCenter.default.post(Notification(name: .loggedIn))
                } label: {
                    CommonSelectButton(title: "로그인",
                                       titleColor: .white,
                                       bgColor: nextButtonBGColor)
                    .disabled(email.isEmpty || pw.isEmpty)
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
        return Color(hex: "#1068FD").opacity(email.isEmpty ? 0.2 : 1.0)
    }
}
