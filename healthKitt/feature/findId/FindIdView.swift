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
    
    @State private var showBottomSheet: Bool = false
    @State private var bottomSheetHeight: CGFloat = 0
    
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
        .sheet(isPresented: $showBottomSheet, content: {
            // 작성 방법 시트
            FindIdResultView(height: $bottomSheetHeight)
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
        })
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
                Button {
                    showBottomSheet.toggle()
                } label: {
                    CommonSelectButton(title: "확인",
                                       titleColor: .white,
                                       bgColor: nextButtonBGColor)
                    .disabled(phone.isEmpty)
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
        return Color(hex: "#1068FD").opacity(phone.isEmpty ? 0.2 : 1.0)
    }
}


struct FindIdResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var height: CGFloat
    
    var body: some View {
        VStack {
            Text("신분증 확인")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            HStack(spacing: 0) {
                Text("등록된 아이디는 ")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#020C1C"))
                Text("jennysbg1108@gmail.com")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
            }
            
            Color.clear
                .frame(height: 40)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                CommonSelectButton(title: "확인",
                                   titleColor: Color(hex: "#1068FD"),
                                   bgColor: Color(hex: "#1068FD").opacity(0.08))
            }
        }
        .padding(.horizontal, 24)
        .readSize { calculatedHeight in
            height = calculatedHeight.height
        }
    }
}
