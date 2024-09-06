//
//  DiaryRandomSurveyView.swift
//  healthKitt
//
//  Created by brian on 9/5/24.
//

import SwiftUI

struct DiaryRandomSurveyView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var showBackAlert: Bool = false
    var body: some View {
        ZStack {
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
                        message: "설문이 완료 되지 않았습니다.\n종료하시겠습니까?",
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
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
    }
    
    var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<7) { index in
                    let title = getCardTitle(from: index)
                    if index == 0 {
                        RandomSurveyCardView(cardIndex: index, title: title, type: .time) { score in
                            print("[TEST] \(title) 점수 : \(score)")
                        }
                    } else if index == 5 {
                        RandomSurveyCardView(cardIndex: index, title: title, type: .voracity) { score in
                            print("[TEST] \(title) 점수 : \(score)")
                        }
                    } else if index == 6 {
                        RandomSurveyCardView(cardIndex: index, title: title, type: .memo) { score in
                            print("[TEST] \(title) 점수 : \(score)")
                        }
                    } else {
                        RandomSurveyCardView(cardIndex: index, title: title) { score in
                            print("[TEST] \(title) 점수 : \(score)")
                        }
                    }
                }
                Spacer()
                CommonSelectButton(title: "완료", titleColor: .white,
                                   bgColor: Color(hex: "#1068FD"),
                                   cornerRadius: 16)
            }
        }
    }
    
    private func getCardTitle(from index: Int) -> String {
        switch index {
        case 0:
            return "언제 음식을 드셨나요?"
        case 1:
            return "음식을 먹기 전에 기분이 좋지 않았나요? (지루하거나 화나거나 스트레스 받는 등)"
        case 2:
            return "음식을 먹고 싶다는 생각에 사로 잡혔었나요?"
        case 3:
            return "절제가 되지 않아 생각했던 것 보다 더 많이 먹었나요?"
        case 4:
            return "음식을 먹고 난 후에도 음식이 먹고 싶었나요?"
        case 5:
            return "폭식 했다고 생각하시나요?"
        case 6:
            return "메모"
        default:
            return ""
        }
    }
}
