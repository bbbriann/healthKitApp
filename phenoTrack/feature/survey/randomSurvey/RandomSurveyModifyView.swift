//
//  RandomSurveyModifyView.swift
//  phenoTrack
//
//  Created by brian on 10/2/24.
//

import SwiftUI

struct RandomSurveyModifyView: View {
    @Binding var path: [HistoryViewStack]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject private var viewModel = RandomSurveyViewModel()
    @Binding var survey: RandomSurvey?
    
    init(path: Binding<[HistoryViewStack]>, survey: Binding<RandomSurvey?>) {
        self._path = path
        self._survey = survey
        if let surveyWrap = survey.wrappedValue {
            self.viewModel.modifyId = surveyWrap.ulid
            self.viewModel.req.questionAAnswer = surveyWrap.questionAAnswer
            self.viewModel.req.questionBAnswer = surveyWrap.questionBAnswer
            self.viewModel.req.questionCAnswer = surveyWrap.questionCAnswer
        }
    }
    
    @State var showBackAlert: Bool = false
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Spinner()
            } else {
                VStack {
                    ZStack {
                        HStack {
                            HStack(alignment: .center, spacing: 16) {
                                Button {
                                    showBackAlert.toggle()
                                } label: {
                                    Image("IcBackBtnBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                Text("랜덤 설문")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "#020C1C"))
                            }
                            Spacer()
                            HStack(alignment: .center) {
                                Text("작성 시각: 오후 07:05")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#020C1C"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.white)
                            .cornerRadius(15)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                    contentView
                        .cornerRadius(24)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity)
                
                if showBackAlert {
                    ZStack {
                        Color.black.opacity(0.4) // 반투명한 배경
                            .ignoresSafeArea()
                        
                        CustomAlertView(
                            title: "확인 통지",
                            message: "설문 수정이 완료 되지 않았습니다.\n종료하시겠습니까?",
                            onCancel: {
                                showBackAlert = false
                            },
                            onConfirm: {
                                showBackAlert = false
                                NotificationCenter.default.post(Notification(name: .showTabBar))
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                        .padding(.horizontal, 24)
                        .transition(.scale)
                        .zIndex(1)
                    }
                }
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
        .onChange(of: viewModel.surveyComplete) { oldValue, newValue in
            guard newValue else { return }
            path.append(.randomSurveyComplete)
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<3) { index in
                let title = getCardTitle(from: index)
                RandomSurveyCardView(cardIndex: index, title: title,
                                     modifyData: .constant(makeData(from: index))) { result in
                    guard case .default(let score) = result else { return }
                    if index == 0 {
                        viewModel.req.questionAAnswer = score
                    } else if index == 1 {
                        viewModel.req.questionBAnswer = score
                    } else if index == 2 {
                        viewModel.req.questionCAnswer = score
                    }
                }
            }
            Spacer()
            Button {
                viewModel.modifyData()
            } label: {
                CommonSelectButton(title: "수정", titleColor: .white,
                                   bgColor: nextButtonBGColor,
                                   cornerRadius: 16)
            }
            .disabled(viewModel.disabledState())
        }
    }
    
    private func getCardTitle(from index: Int) -> String {
        switch index {
        case 0:
            return "지금 음식이 먹고 싶은 가요?"
        case 1:
            return "지금 기분이 어떤 가요?"
        case 2:
            return "지금 스트레스를 받고 있나요?"
        default:
            return ""
        }
    }
    
    private func makeData(from index: Int) -> RandomDataResult {
        let value: Int
        switch index {
        case 0:
            value = viewModel.req.questionAAnswer
        case 1:
            value = viewModel.req.questionBAnswer
        case 2:
            value = viewModel.req.questionCAnswer
        default:
            value = 0
        }
        
        return .default(value: value)
    }
    
    var nextButtonBGColor: Color {
        return Color(hex: "#1068FD").opacity(viewModel.disabledState() ? 0.2 : 1.0)
    }
}
