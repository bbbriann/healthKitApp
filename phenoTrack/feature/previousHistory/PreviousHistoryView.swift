//
//  PreviousHistoryView.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import Charts
import SwiftUI

struct PreviousHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedDate = Date()
    @State private var selectedIndex: Int = 0
    @State private var showRandomSurveyResultView: Bool = false
    @State private var showDiaryResultView: Bool = false
    private var calendar = Calendar.current
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private var dataList = ["09:35","12:30","14:25","17:12","20:32"]
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        NotificationCenter.default.post(Notification(name: .showTabBar))
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("IcBackBtnBlue")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("지난 기록")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .padding(.horizontal, 24)
            
            ZStack {
                VStack(spacing: 20) {
                    CustomSegmentedControl(preselectedIndex: $selectedIndex, options: ["랜덤 설문", "식사 일기"])
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            randomChartView
                            rnndomDetailView
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, safeAreaInsets.bottom)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
            }
            
            NavigationLink(destination: RandomSurveyResultView(randomSurvey: .constant(nil)), isActive: $showRandomSurveyResultView) {
                EmptyView()
            }
            
            NavigationLink(destination: DiaryResultView(diet: .constant(nil)), isActive: $showDiaryResultView) {
                EmptyView()
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
    }
    
    var randomChartView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("신고 - 5건")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
                
                HStack(alignment: .center, spacing: 2) {
                    Text(selectedDate.toYYYYMMDDKRString())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                    Image("IcBlueArrowDown")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
                .padding(.vertical, 4)
                .frame(height: 24, alignment: .leading)
                .background(.white)
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            if selectedIndex == 0 {
                Chart {
                    // ForEach를 각 질문의 카테고리로 처리
                    ForEach(["음식 생각", "기분", "스트레스"], id: \.self) { category in
                        ForEach(viewModel.randomSurveyList, id: \.ulid) { survey in
                            if let date = convertToDate(survey.created) {
                                LineMark(
                                    x: .value("Time", date),
                                    y: .value(category, value(for: category, from: survey))
                                )
                                .foregroundStyle(by: .value("Category", category))
                                .symbol(by: .value("Category", category))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            }
                        }
                    }
                }
                .chartForegroundStyleScale([
                    "음식 생각": Color.blue,
                    "기분": Color.red,
                    "스트레스": Color.purple
                ])
                .chartLegend(position: .top, alignment: .leading)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 2)) { value in
                        if let dateValue = value.as(Date.self) {
                            AxisValueLabel(formatDate(date: dateValue))
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 300)
            } else {
                List {
                    // 전체 Diet 리스트를 요약하여 차트 5개로 표현
                    HistoryResultCardView(
                        title: "음식을 먹기 전에 기분이 좋지 않았나요?",
                        description: "(지루하거나 화나거나 스트레스 받는 등)",
                        positiveCount: totalFor(question: \.questionAAnswer),
                        totalResponses: totalResponses()
                    )
                    
                    HistoryResultCardView(
                        title: "음식을 먹고 싶다는 생각에 사로 잡혔었나요?",
                        description: "(강하게 음식을 원했던 경험)",
                        positiveCount: totalFor(question: \.questionBAnswer),
                        totalResponses: totalResponses()
                    )
                    
                    HistoryResultCardView(
                        title: "절제하지 않고 생각했던 것 보다 더 많이 먹었나요?",
                        description: "(계획한 것보다 더 많이 섭취)",
                        positiveCount: totalFor(question: \.questionCAnswer),
                        totalResponses: totalResponses()
                    )
                    
                    HistoryResultCardView(
                        title: "음식을 먹고 난 후에도 음식을 먹고 싶었나요?",
                        description: "(포만감이 느껴지지 않음)",
                        positiveCount: totalFor(question: \.questionDAnswer),
                        totalResponses: totalResponses()
                    )
                    
                    HistoryResultCardView(
                        title: "폭식했다고 느끼셨나요?",
                        description: "(많이 먹었을 때의 느낌)",
                        positiveCount: totalFor(question: \.questionEAnswer),
                        totalResponses: totalResponses()
                    )
                }
            }
        }
    }
    
    var rnndomDetailView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("상세")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<dataList.count) { index in
                    Button {
                        if selectedIndex == 0 {
                            showRandomSurveyResultView.toggle()
                        } else {
                            showDiaryResultView.toggle()
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 10) {
                            Color
                                .clear
                                .frame(width: 20, height: 10)
                            Text(dataList[index])
                                .font(.system(size: 16, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "#020C1C"))
                                .frame(maxWidth: .infinity, alignment: .center)
                            Image("IcRightArrowBlue")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(.white)
                        .cornerRadius(12)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func convertToDate(_ dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 시간대로 설정
        isoFormatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        return isoFormatter.date(from: dateString)
    }
    
    private func value(for category: String, from survey: RandomSurvey) -> Int {
        switch category {
        case "음식 생각":
            return survey.questionAAnswer
        case "기분":
            return survey.questionBAnswer
        case "스트레스":
            return survey.questionCAnswer
        default:
            return 0
        }
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 시간과 분을 두 자리 숫자로 표시
        return dateFormatter.string(from: date)
    }
    
    // 전체 Diet 배열에서 특정 질문 답변의 합계 계산
    private func totalFor(question keyPath: KeyPath<Diet, Int>) -> Int {
        return viewModel.dietList.reduce(0) { $0 + $1[keyPath: keyPath] }
    }
    
    // 전체 응답의 개수를 계산 (모든 Diet에 동일한 총 응답 수를 가정)
    private func totalResponses() -> Int {
        return viewModel.dietList.count * 6 // 응답이 6개씩인 것으로 가정
    }
}
