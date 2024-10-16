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
    
    @State private var showBottomSheet: Bool = false
    @State private var bottomSheetHeight: CGFloat = 0
    
    @StateObject private var viewModel = FindIdViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Spinner()
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
                
                
                
                if viewModel.emptyResult {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "오류",
                            message: "일치하는 전화번호가 없습니다.\n다시 시도해주세요.",
                            onlyConfirm: true,
                            onCancel: { },
                            onConfirm: {
                                viewModel.emptyResult.toggle()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                }
            }
        }
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
            FindIdResultView(email: viewModel.foundEmail, height: $bottomSheetHeight)
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
        })
        .onChange(of: viewModel.foundEmail) { oldValue, newValue in
            guard !newValue.isEmpty else { return }
            showBottomSheet.toggle()
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
                    CommonInputView(text: $viewModel.phone, image: "IcPhone",
                                    placeholder: "휴대폰 번호 입력", keyboardType: .phonePad)
                }
                
                Spacer()
                Button {
                    viewModel.searchId()
                } label: {
                    CommonSelectButton(title: "확인",
                                       titleColor: .white,
                                       bgColor: nextButtonBGColor)
                    .disabled(viewModel.phone.isEmpty)
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
        return Color(hex: "#1068FD").opacity(viewModel.phone.isEmpty ? 0.2 : 1.0)
    }
}


struct FindIdResultView: View {
    @Environment(\.presentationMode) var presentationMode
    var email: String
    @Binding var height: CGFloat
    
    var body: some View {
        VStack {
            Text("아이디 확인")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            HStack(spacing: 0) {
                Text("등록된 아이디는 ")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#020C1C"))
                Text(email)
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
