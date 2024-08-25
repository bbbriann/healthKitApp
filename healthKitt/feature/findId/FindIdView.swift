//
//  FindIdView.swift
//  healthKitt
//
//  Created by brian on 8/21/24.
//

import SwiftUI

struct FindIdView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var phone: String = ""
    
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
        .navigationBarTitle("아이디 찾기")
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
                Text("가입시 등록한 휴대폰 번호를\n입력해 주세요")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(width: 345, alignment: .topLeading)
                VStack(spacing: 12) {
                    CommonInputView(text: $phone, image: "IcPhone", placeholder: "휴대폰 번호 입력")
                }
                
                Spacer()
                
                CommonSelectButton(title: "확인",
                                   titleColor: .white,
                                   bgColor: nextButtonBGColor)
                .disabled(phone.isEmpty)
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
        return Color(hex: "#1068FD").opacity(phone.isEmpty ? 0.2 : 1.0)
    }
}
