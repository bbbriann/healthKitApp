//
//  HistoryView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import Charts
import SwiftUI

struct HistoryView: View {
    @State private var path: [HistoryViewStack] = []
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedIndex: Int = 0
    @State private var hasCalendarButtonPressed: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
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
                        .padding(.bottom, 130)
                        .frame(maxWidth: .infinity)
                        .refreshable {
                            if selectedIndex == 0 {
                                viewModel.fetchRandomSurveyListData()
                            } else {
                                viewModel.fetchDietsData()
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .background(Color(red: 0.95, green: 0.96, blue: 0.98))
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        }
        .onChange(of: selectedIndex) { oldValue, newValue in
            if newValue == 0 {
                viewModel.fetchRandomSurveyListData()
            } else {
                viewModel.fetchDietsData()
            }
        }
        .onChange(of: viewModel.selectedDate) { oldValue, newValue in
            if selectedIndex == 0 {
                viewModel.fetchRandomSurveyListData()
            } else {
                viewModel.fetchDietsData()
            }
        }
        .onAppear {
            if selectedIndex == 0 {
                viewModel.fetchRandomSurveyListData()
            } else {
                viewModel.fetchDietsData()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataRefresh)) { notification in
            if selectedIndex == 0 {
                viewModel.fetchRandomSurveyListData()
            } else {
                viewModel.fetchDietsData()
            }
        }
        .navigationDestination(for: HistoryViewStack.self) { viewType in
            switch viewType {
            case .history:
                EmptyView()
            case .randomSurveyResult:
                RandomSurveyResultView(historyPath: $path, homePath: .constant([]),
                                       randomSurvey: $viewModel.selectedRandomSurvey)
            case .randomSurveyModify:
                RandomSurveyModifyView(path: $path, survey: $viewModel.selectedRandomSurvey)
            case .randomSurveyComplete:
                RandomSurveyModifyCompleteView(path: $path)
            case .diaryResult:
                DiaryResultView(diaryPath: .constant([]), 
                                historyPath: $path,
                                homePath: .constant([]),
                                diet: $viewModel.selectedDiet)
            case .diaryModify:
                DiaryRandomSurveyModifyView(diaryPath: .constant([]),
                                            historyPath: $path,
                                            selectedDate: viewModel.selectedDate,
                                            diet: $viewModel.selectedDiet)
            case .diaryModifyComplete:
                DiaryRandomSurveyCompleteView(diaryPath: .constant([]),
                                              historyPath: $path,
                                              title: "설문 수정 완료")
            default:
                EmptyView()
            }
        }
    }
    
    var randomChartView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("보고 - \(viewModel.reportedCount(index: selectedIndex))건")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
                
                Button {
                    hasCalendarButtonPressed.toggle()
                } label: {
                    HStack(alignment: .center, spacing: 2) {
                        Text(viewModel.selectedDate.toYYYYMMDDKRString())
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
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            if hasCalendarButtonPressed {
                CalenderView(clickedCurrentMonthDates: $viewModel.selectedDate,
                             hasCalendarButtonPressed: $hasCalendarButtonPressed)
                .padding(.top, 30)
            }
            if selectedIndex == 0 {
                if !viewModel.randomSurveyList.isEmpty {
                    ZStack {
                        Chart {
                            // ForEach를 각 질문의 카테고리로 처리
                            ForEach(["음식 생각", "기분", "스트레스"], id: \.self) { category in
                                ForEach(viewModel.randomSurveyList, id: \.ulid) { survey in
                                    if let date = DateHelper.convertToDate(survey.created) {
                                        LineMark(
                                            x: .value("Time", date),
                                            y: .value(category, value(for: category, from: survey))
                                        )
                                        .foregroundStyle(by: .value("Category", category))
                                        .symbol {
                                            Circle()
                                                .fill(color(for: category))
                                                .frame(width: 5, height: 5)
                                        }
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
                        .chartLegend(position: .top, alignment: .leading, spacing: 20)
                        .chartYScale(domain: 1...5)
                        .chartXScale(domain: createDateRange())
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                                if let dateValue = value.as(Date.self) {
                                    AxisValueLabel(formatDate(date: dateValue))
                                        .offset(y: 8)
                                }
                                // X축 눈금선 추가
                                AxisGridLine()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .chartPlotStyle { plotArea in
                            plotArea
                                .padding(.leading, 10) // Y축과 차트 간의 간격 추가
                                .padding(.bottom, 10)  // X축과 차트 간의 간격 추가
                        }
                    .padding(20)
                    .background(.white)
                    .cornerRadius(12)
                    .frame(height: 300)
                }
            } else {
                if !viewModel.dietList.isEmpty {
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
                        positiveCount: totalFor(question: \.questionEAnswer, isQuestionE: true),
                        totalResponses: totalResponses()
                    )
                }
            }
        }
    }
    
    private func createDateRange() -> ClosedRange<Date> {
        let calendar = Calendar.current

        // viewModel.randomSurveyList의 첫 번째 날짜를 사용하거나, 없으면 현재 날짜를 사용
        let baseDate: Date
        if let createdString = viewModel.randomSurveyList.first?.created,
           let date = DateHelper.convertToDate(createdString) {
            baseDate = date
        } else {
            baseDate = Date() // 첫 번째 날짜가 없으면 현재 날짜 사용
        }
        
        // 9:00 AM 설정
        var startComponents = calendar.dateComponents([.year, .month, .day], from: baseDate)
        startComponents.hour = 8
        let start = calendar.date(from: startComponents) ?? baseDate

        // 9:00 PM 설정
        var endComponents = calendar.dateComponents([.year, .month, .day], from: baseDate)
        endComponents.hour = 22
        let end = calendar.date(from: endComponents) ?? baseDate

        return start...end
    }
    
    var rnndomDetailView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("상세 보기")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            VStack(alignment: .leading, spacing: 8) {
                if selectedIndex == 0 {
                    ForEach(viewModel.randomSurveyList, id: \.self) { item in
                        Button {
                            viewModel.selectedRandomSurvey = item
                            path.append(.randomSurveyResult)
                        } label: {
                            HStack(alignment: .center, spacing: 10) {
                                Color
                                    .clear
                                    .frame(width: 20, height: 10)
                                Text(DateHelper.formatTimeFromISO8601(item.created) ?? "")
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
                } else {
                    ForEach(viewModel.dietList, id: \.self) { item in
                        Button {
                            viewModel.selectedDiet = item
                            path.append(.diaryResult)
                        } label: {
                            HStack(alignment: .center, spacing: 10) {
                                Color
                                    .clear
                                    .frame(width: 20, height: 10)
                                Text(DateHelper.formatTimeFromISO8601(item.created) ?? "")
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
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func value(for category: String, from survey: RandomSurvey) -> Int {
        switch category {
        case "음식 생각":
            return survey.questionAAnswer + 1
        case "기분":
            return survey.questionBAnswer + 1
        case "스트레스":
            return survey.questionCAnswer + 1
        default:
            return 0
        }
    }
    
    private func color(for category: String) -> Color {
        switch category {
        case "음식 생각":
            return Color.blue
        case "기분":
            return Color.red
        case "스트레스":
            return Color.purple
        default:
            return .clear
        }
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 시간과 분을 두 자리 숫자로 표시
        return dateFormatter.string(from: date)
    }
    
    // 전체 Diet 배열에서 특정 질문 답변의 긍정적인 응답 수 계산
    private func totalFor(question keyPath: KeyPath<Diet, Int>, isQuestionE: Bool = false) -> Int {
        return viewModel.dietList.reduce(0) { total, diet in
            let answer = diet[keyPath: keyPath]
            if isQuestionE {
                // questionE는 2일 경우만 긍정적 응답으로 계산
                return total + (answer == 2 ? 1 : 0)
            } else {
                // questionA, B, C, D는 3 또는 4일 경우만 긍정적 응답으로 계산
                return total + (answer == 3 || answer == 4 ? 1 : 0)
            }
        }
    }
    
    // 전체 응답의 개수를 계산 (모든 Diet에 동일한 총 응답 수를 가정)
    private func totalResponses() -> Int {
        return viewModel.dietList.count // 응답이 6개씩인 것으로 가정
    }
}
