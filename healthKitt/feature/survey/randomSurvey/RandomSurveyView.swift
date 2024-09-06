//
//  RandomSurveyView.swift
//  healthKitt
//
//  Created by brian on 9/1/24.
//

import SwiftUI

struct RandomSurveyView: View {
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
//        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
//        .padding(.bottom, safeAreaInsets.bottom)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<3) { index in
                let title = getCardTitle(from: index)
                RandomSurveyCardView(cardIndex: index, title: title) { score in
                    print("[TEST] \(title) 점수 : \(score)")
                }
            }
            Spacer()
            CommonSelectButton(title: "완료", titleColor: .white,
                               bgColor: Color(hex: "#1068FD"),
                               cornerRadius: 16)
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
}
