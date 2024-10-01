//
//  RandomSurveyResultView.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import SwiftUI

// MARK: - RandomSurvey
struct RandomSurvey: Codable, Hashable {
    let ulid: String
    let questionAAnswer, questionBAnswer, questionCAnswer: Int
    let created, modified: String

    enum CodingKeys: String, CodingKey {
        case ulid
        case questionAAnswer = "question_a_answer"
        case questionBAnswer = "question_b_answer"
        case questionCAnswer = "question_c_answer"
        case created, modified
    }
    
    func getAnswerText(index: Int) -> String {
        switch index {
        case 0, 1, 2:
            var answer = 0
            if index == 0 {
                answer = self.questionAAnswer
            } else if index == 1 {
                answer = self.questionBAnswer
            } else if index == 2 {
                answer = self.questionCAnswer
            }
            
            if answer == 0 {
                return "전혀 아니다"
            } else if answer == 1 {
                return "아니다"
            } else if answer == 2 {
                return "보통이다"
            } else if answer == 3 {
                return "그렇다"
            } else {
                return "매우 그렇다"
            }
        default:
            return ""
        }
    }
}


struct RandomSurveyResultView: View {
    @Binding var path: [HistoryViewStack]
    @Binding var randomSurvey: RandomSurvey?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var showDeleteAlert: Bool = false
    @StateObject private var viewModel = RandomSurveyResultViewModel()
    
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
                                    NotificationCenter.default.post(Notification(name: .showTabBar))
                                    presentationMode.wrappedValue.dismiss()
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
                            
                            HStack(alignment: .center, spacing: 2) {
                                Text(DateHelper.formatTimeFromISO8601(randomSurvey?.created ?? "") ?? "")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#020C1C"))
                            }
                            .padding(.leading, 12)
                            .padding(.trailing, 8)
                            .padding(.vertical, 4)
                            .frame(height: 24, alignment: .leading)
                            .background(.white)
                            .cornerRadius(12)
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
            }
            
            if showDeleteAlert {
                ZStack {
                    Color.black.opacity(0.4) // 반투명한 배경
                        .ignoresSafeArea()
                    
                    CustomAlertView(
                        title: "랜덤 설문 삭제",
                        message: "랜덤 설문을 삭제하시겠습니까?",
                        confirmTitle: "삭제",
                        onCancel: {
                            showDeleteAlert = false
                        },
                        onConfirm: {
                            showDeleteAlert = false
                            if let ulid = randomSurvey?.ulid {
                                viewModel.deleteData(ulid: ulid)
                            }
                        }
                    )
                    .padding(.horizontal, 24)
                    .transition(.scale)
                    .zIndex(1)
                }
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
        .onChange(of: viewModel.deleteComplete) { oldValue, newValue in
            guard newValue else { return }
            NotificationCenter.default.post(Notification(name: .showTabBar))
            NotificationCenter.default.post(Notification(name: .dataRefresh))
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3) { index in
                    let title = getCardTitle(from: index)
                    let content = randomSurvey?.getAnswerText(index: index) ?? ""
                    DiaryResultCardView(cardIndex: index, title: title, content: content)
                }
                Spacer()
                HStack(alignment: .top, spacing: 12) {
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        CommonSelectButton(title: "삭제", titleColor: .white,
                                           bgColor: Color(hex: "#DA072D"))
                    }
                    Button {
                        path.append(.randomSurveyModify)
                    } label: {
                        CommonSelectButton(title: "수정", titleColor: .white,
                                           bgColor: Color(hex: "#1068FD"))
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
    
    private func getCardTitle(from index: Int) -> String {
        switch index {
        case 0:
            return "지금 음식이 먹고 싶은가요?"
        case 1:
            return "지금 기분이 어떤가요?"
        case 2:
            return "지금 스트레스를 받고 있나요?"
        default:
            return ""
        }
    }
}
