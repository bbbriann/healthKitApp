//
//  HistoryView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import Charts
import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
//    @State private var selectedDate = Date()
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
                    Spacer()
                    Text("식사 일기")
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
                }
                .padding(.horizontal, 24)
            }
            
            NavigationLink(destination: RandomSurveyResultView(randomSurvey: $viewModel.selectedRandomSurvey), isActive: $showRandomSurveyResultView) {
                EmptyView()
            }
            
            NavigationLink(destination: DiaryResultView(diet: $viewModel.selectedDiet), isActive: $showDiaryResultView) {
                EmptyView()
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedIndex) { oldValue, newValue in
            if newValue == 0 {
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
    }
    
    var randomChartView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("신고 - \(viewModel.reportedCount(index: selectedIndex))건")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
                
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
            .frame(maxWidth: .infinity, alignment: .center)
            if selectedIndex == 0 {
                Chart(viewModel.moodData) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.time),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(by: .value("Category", dataPoint.category))
                    .symbol(by: .value("Category", dataPoint.category))
                }
                .chartForegroundStyleScale([
                    "음식 생각": Color.blue,
                    "기분": Color.red,
                    "스트레스": Color.purple
                ])
                .chartLegend(position: .top, alignment: .leading)
                .frame(height: 300)
                .padding()
            } else {
                HistoryResultCardView()
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
                if selectedIndex == 0 {
                    ForEach(viewModel.randomSurveyList, id: \.self) { item in
                        Button {
                            viewModel.selectedRandomSurvey = item
                            showRandomSurveyResultView.toggle()
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
                            showDiaryResultView.toggle()
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
}
