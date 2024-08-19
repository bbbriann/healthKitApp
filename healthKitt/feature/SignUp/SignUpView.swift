//
//  SignUpView.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var email: String = ""
    
    var body: some View {
        VStack {
//            headerView
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
        .navigationBarTitle("회원 가입")
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
                Text("로그인에 사용할\n아이디(이메일)를 입력해 주세요")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(width: 345, alignment: .topLeading)
                CommonInputView(text: $email, image: "IcEmail", placeholder: "이메일 입력")
                
                Spacer()
                
                CommonSelectButton(title: "다음 ( 1/4 )",
                                   titleColor: .white,
                                   bgColor: nextButtonBGColor)
                .disabled(email.isEmpty)
                .padding(.bottom, safeAreaInsets.bottom)
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
