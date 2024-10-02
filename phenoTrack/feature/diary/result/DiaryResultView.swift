//
//  DiaryResultView.swift
//  healthKitt
//
//  Created by brian on 9/7/24.
//

import SwiftUI

struct DiaryResultView: View {
    @Binding var diaryPath: [DiaryViewStack]
    @Binding var historyPath: [HistoryViewStack]
    @Binding var diet: Diet?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var showDeleteAlert: Bool = false
    @StateObject private var viewModel = DiaryResultViewModel()
    
    @State var selectedDate: Date = Date()
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
                                Text("식사 일기")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "#020C1C"))
                            }
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 2) {
                                Text(getDateTitle(diet?.whenToEat ?? "") ?? "")
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
                        title: "식사 이력 삭제",
                        message: "식사 이력을 삭제하시겠습니까?",
                        confirmTitle: "삭제",
                        onCancel: {
                            showDeleteAlert = false
                        },
                        onConfirm: {
                            showDeleteAlert = false
                            if let ulid = diet?.ulid {
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
                ForEach(0..<6) { index in
                    let title = getCardTitle(from: index)
                    var content = diet?.getAnswerText(index: index) ?? ""
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
                        if diaryPath.isEmpty {
                            historyPath.append(.diaryModify)
                        } else {
                            diaryPath.append(.diaryModify)
                        }
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
            return "음식을 먹기 전에 기분이 좋지 않았나요? (지루하거나 화나거나 스트레스 받는 등)"
        case 1:
            return "음식을 먹고 싶다는 생각에 사로 잡혔었나요?"
        case 2:
            return "절제가 되지 않아 생각했던 것 보다 더 많이 먹었나요?"
        case 3:
            return "음식을 먹고 난 후에도 음식이 먹고 싶었나요?"
        case 4:
            return "폭식 했다고 생각하시나요?"
        case 5:
            return "메모"
        default:
            return ""
        }
    }
    
    private func getDateTitle(_ isoDateString: String) -> String? {
        // 1. ISO 8601 형식의 문자열을 Date로 변환
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoFormatter.date(from: isoDateString) else {
            return nil
        }
        return date.toYYYYMMDDKRString()
    }
}

struct DiaryResultCardView: View {
    let cardIndex: Int
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더
            HStack(alignment: .center, spacing: 12) {
                // 숫자
                HStack(alignment: .center, spacing: 4) {
                    Text((cardIndex + 1).toTwoDigits())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: "#1068FD"))
                .cornerRadius(8)
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 64, alignment: .center)
            .background(.white)
            .border(width: 1, edges: [.bottom], color: .black.opacity(0.1))
            VStack(alignment: .center) {
                Text(content)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(12)
    }
}
