//
//  SignUpView.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var path: [StackViewType]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = SignupViewModel()
    @State private var hasCalendarButtonPressed: Bool = false
    @State private var hasCompleted: Bool = false
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spinner()
            } else {
                Spacer(minLength: 61)
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .cornerRadius(24)
                        .rotationEffect(Angle(degrees: -4))
                    contentView
                        .cornerRadius(24)
                }
                .background {
                    NavigationLink(
                        destination: AuthCompleteView(path: $path),
                        isActive: $hasCompleted,
                        label: {
                            EmptyView() // 빈 뷰로 레이아웃에 표시되지 않도록 함
                        }
                    )
                }
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
        .onChange(of: viewModel.signUpFinished) { value in
            guard value else { return }
            hasCompleted = true
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
                switch viewModel.step {
                case .email:
                    emailView
                case .password:
                    pwView
                case .phone:
                    phoneView
                case .info:
                    profileView
                case .done:
                    EmptyView()
                }
                Button {
                    viewModel.handleStep()
                } label: {
                    let text = "다음 ( \(viewModel.currentStepIdx)/4 )"
                    CommonSelectButton(title: text,
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
    
    private var emailView: some View {
        Group {
            Text("로그인에 사용할\n아이디(이메일)를 입력해 주세요")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(width: 345, alignment: .topLeading)
            CommonInputView(text: $viewModel.email,
                            image: "IcEmail", placeholder: "이메일 입력")
            
            Spacer()
        }
    }
    
    private var pwView: some View {
        Group {
            Text("로그인에 사용할 비밀번호를\n입력해 주세요")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(width: 345, alignment: .topLeading)
            CommonInputView(text: $viewModel.pw, image: "IcPW",
                            placeholder: "비밀번호 입력", isSecure: true)
            CommonInputView(text: $viewModel.pwConfirm, image: "IcPW",
                            placeholder: "비밀번호를 다시 확인하세요", isSecure: true)
            
            Spacer()
        }
    }
    
    private var phoneView: some View {
        Group {
            Text("현재 소지하고 계시는 휴대폰 번호를\n입력해 주세요")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(width: 345, alignment: .topLeading)
            CommonInputView(text: $viewModel.phoneNumber, image: "IcPhone",
                            placeholder: "전화번호를 다시 입력하세요")
            
            Spacer()
        }
    }
    
    private var profileView: some View {
        Group {
            Text("간단한 정보를 알려주세요")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(width: 345, alignment: .topLeading)
            CommonInputView(text: $viewModel.name, image: "IcProfile",
                            placeholder: "이름(실명)")
            Button {
                hasCalendarButtonPressed.toggle()
            } label: {
                CalendarInputView(date: $viewModel.birth, image: "IcBirth")
            }
            
            if hasCalendarButtonPressed {
                CalenderView(clickedCurrentMonthDates: $viewModel.birth,
                             hasCalendarButtonPressed: $hasCalendarButtonPressed)
                    .padding(.top, 30)
            }
            if !hasCalendarButtonPressed {
                CommonInputView(text: .constant("성별"), image: "IcGender",
                                specificType: .birth, gender: $viewModel.gender)
            }
            Spacer()
        }
    }
    
    
    
    var nextButtonBGColor: Color {
        return viewModel.getNextButtonColor()
    }
}
