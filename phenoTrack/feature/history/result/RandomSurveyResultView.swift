//
//  RandomSurveyResultView.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import SwiftUI

struct RandomSurveyResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var showBackAlert: Bool = false
    
    @State var selectedDate: Date = Date()
    var body: some View {
        ZStack {
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
                            Text(selectedDate.toYYYYMMDDKRString())
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
                ForEach(0..<3) { index in
                    let title = getCardTitle(from: index)
                    DiaryResultCardView(cardIndex: index, title: title, content: "hihihihi")
                }
                Spacer()
                HStack(alignment: .top, spacing: 12) {
                    CommonSelectButton(title: "삭제", titleColor: .white,
                                       bgColor: Color(hex: "#DA072D"))
                    CommonSelectButton(title: "수정", titleColor: .white,
                                       bgColor: Color(hex: "#1068FD"))
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
