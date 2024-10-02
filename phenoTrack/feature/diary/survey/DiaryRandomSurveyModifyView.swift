//
//  DiaryRandomSurveyModifyView.swift
//  phenoTrack
//
//  Created by brian on 10/3/24.
//

import SwiftUI

struct DiaryRandomSurveyModifyView: View {
    @Binding var diaryPath: [DiaryViewStack]
    @Binding var historyPath: [HistoryViewStack]
    var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject private var viewModel = DiaryRandomSurveyViewModel()
    
    @Binding var diet: Diet?
    
    init(diaryPath: Binding<[DiaryViewStack]>, historyPath: Binding<[HistoryViewStack]>, selectedDate: Date, diet: Binding<Diet?>) {
        self._diaryPath = diaryPath
        self._historyPath = historyPath
        self._diet = diet
        self.selectedDate = selectedDate
        if let diet = diet.wrappedValue {
            self.viewModel.modifyId = diet.ulid
            self.viewModel.req.whenToEat = diet.whenToEat
            self.viewModel.req.questionAAnswer = diet.questionAAnswer
            self.viewModel.req.questionBAnswer = diet.questionBAnswer
            self.viewModel.req.questionCAnswer = diet.questionCAnswer
            self.viewModel.req.questionDAnswer = diet.questionDAnswer
            self.viewModel.req.questionEAnswer = diet.questionEAnswer
            self.viewModel.req.memo = diet.memo
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
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
            let isoDate = self.formatToISO8601(date: selectedDate)
            viewModel.req.whenToEat = isoDate
        }
        .onChange(of: viewModel.surveyComplete) { oldValue, newValue in
            guard newValue else { return }
            if diaryPath.isEmpty {
                historyPath.append(.diaryModifyComplete)
            } else {
                diaryPath.append(.diaryModifyComplete)
            }
        }
    }
    
    var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<7) { index in
                    let title = getCardTitle(from: index)
                    // 시간
                    if index == 0 {
                        RandomSurveyCardView(cardIndex: index, title: title,
                                             modifyData: .constant(makeData(from: index)), type: .time) { result in
                            guard case .time(let hour, let min) = result else { return }
                            guard let date = self.updateDateWith(hour: hour, minute: min, from: selectedDate) else { return }
                            let isoDate = self.formatToISO8601(date: date)
                            print("[TEST] \(title) 시: \(hour), 분: \(min) 날 \(date) isoDate \(isoDate)")
                            
                            viewModel.req.whenToEat = isoDate
                        }
                    // 폭식
                    } else if index == 5 {
                        RandomSurveyCardView(cardIndex: index, title: title, 
                                             modifyData: .constant(makeData(from: index)),
                                             type: .voracity) { result in
                            guard case .voracity(let score) = result else { return }
                            print("[TEST] \(title) 점수 : \(score)")
                            viewModel.req.questionEAnswer = score
                        }
                    // 메모
                    } else if index == 6 {
                        RandomSurveyCardView(cardIndex: index, title: title, 
                                             modifyData: .constant(makeData(from: index)),
                                             type: .memo) { result in
                            guard case .memo(let memoStr) = result else { return }
                            print("[TEST] \(title) 메모 : \(memoStr)")
                            viewModel.req.memo = memoStr
                        }
                    } else {
                        RandomSurveyCardView(cardIndex: index, title: title,
                                             modifyData: .constant(makeData(from: index))) { result in
                            guard case .default(let score) = result else { return }
                            if index == 1 {
                                viewModel.req.questionAAnswer = score
                            } else if index == 2 {
                                viewModel.req.questionBAnswer = score
                            } else if index == 3 {
                                viewModel.req.questionCAnswer = score
                            } else if index == 4 {
                                viewModel.req.questionDAnswer = score
                            }
                            print("[TEST] \(title) 점수 : \(score)")
                        }
                    }
                }
                Spacer()
                Button {
                    viewModel.modifyData()
                } label: {
                    CommonSelectButton(title: "수정", titleColor: .white,
                                       bgColor: Color(hex: "#1068FD"),
                                       cornerRadius: 16)
                }
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
    
    private func makeData(from index: Int) -> RandomDataResult {
        let value: Int
        switch index {
            // 시간
        case 0:
            guard let whenToEat = viewModel.req.whenToEat,
                  let (hour, min) = DateHelper.getHourMin(from: whenToEat) else {
                return .time(hour: 0, min: 0)
            }
            return .time(hour: hour, min: min)
        case 1:
            return .default(value: viewModel.req.questionAAnswer)
        case 2:
            return .default(value: viewModel.req.questionBAnswer)
        case 3:
            return .default(value: viewModel.req.questionCAnswer)
        case 4:
            return .default(value: viewModel.req.questionDAnswer)
        case 5:
            return .default(value: viewModel.req.questionEAnswer)
        case 6:
            return .memo(value: viewModel.req.memo)
        default:
            return .default(value: 0)
        }
    }
    
    private func updateDateWith(hour: Int, minute: Int, from originalDate: Date) -> Date? {
        let calendar = Calendar.current
        
        // DateComponents로 기존 날짜의 년/월/일 정보 가져오기
        var components = calendar.dateComponents([.year, .month, .day], from: originalDate)
        
        // 선택한 hour와 minute을 설정
        components.hour = hour
        components.minute = minute
        
        // Calendar를 사용하여 새로운 날짜 생성
        return calendar.date(from: components)
    }
    
    private func formatToISO8601(date: Date) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 시간대로 설정
        isoFormatter.formatOptions = [.withInternetDateTime] // ISO 8601 포맷 옵션
        return isoFormatter.string(from: date)
    }
}
