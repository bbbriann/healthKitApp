//
//  DiaryView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import SwiftUI

struct DiaryView: View {
    @State private var path: [DiaryViewStack] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
//    @State private var selectedDate = Date()
    @State private var hasCalendarButtonPressed = false
    @State private var showRandomSurveyView: Bool = false
    @State private var showDiaryResultView: Bool = false
    @StateObject private var viewModel = DiaryViewModel()
    private var calendar = Calendar.current
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if viewModel.isLoading {
                    Spinner()
                } else {
                    ZStack {
                        HStack {
                            Text("식사 일기")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                hasCalendarButtonPressed.toggle()
                            } label: {
                                HStack(alignment: .center, spacing: 2) {
                                    Text(viewModel.selectedDate.toYYYYMMDDKRString())
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(hex: "#020C1C"))
//                                    Image("IcBlueArrowDown")
//                                        .resizable()
//                                        .frame(width: 16, height: 16)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 8)
                                .padding(.vertical, 4)
                                .frame(height: 24, alignment: .leading)
                                .background(.white)
                                .cornerRadius(12)
                            }
                        }
                        
//                        if hasCalendarButtonPressed {
//                            CalenderView(clickedCurrentMonthDates: $viewModel.selectedDate,
//                                         hasCalendarButtonPressed: $hasCalendarButtonPressed)
//                            .padding(.top, 400)
//                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                    .padding(.horizontal, 24)
                    .zIndex(999)
                    
                    
                    CalendarScrollView(currentDate: $viewModel.selectedDate)
                        .padding(.horizontal, 24)
                        .frame(height: 72)
                    Spacer(minLength: 61)
                    ZStack {
                        contentView
                            .cornerRadius(24)
                    }
                }
            }
            .background(Color(hex: "#1068FD"))
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: DiaryViewStack.self) { viewType in
                switch viewType {
                case .diarySurvey:
                    DiaryRandomSurveyView(path: $path, selectedDate: viewModel.selectedDate)
                case .diarySurveyComplete:
                    DiaryRandomSurveyCompleteView(path: $path)
                case .diary:
                    EmptyView()
                case .result:
                    DiaryResultView(diet: $viewModel.selectedDiet)
                }
            }
            .onChange(of: viewModel.selectedDate) { oldValue, newValue in
                viewModel.fetchData()
            }
        }
        .onAppear {
            Task {
                viewModel.fetchData()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataRefresh)) { notification in
            viewModel.fetchData()
        }
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackButtonView()
        }
    }
    
    var contentView: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 32) {
                    infoView
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .background(Color(hex: "#F1F5F9"))
        .cornerRadius(24)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("기록")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.dietList, id: \.self) { item in
                        Button {
                            viewModel.selectedDiet = item
                            path.append(.result)
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
                    Button {
                        path.append(.diarySurvey)
                    } label: {
                        HistoryAddButtonView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

enum DateHelper {
    static func formatTimeFromISO8601(_ isoDateString: String, needFractionSecondes: Bool = true) -> String? {
        // 1. ISO 8601 형식의 문자열을 Date로 변환
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if needFractionSecondes {
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            isoFormatter.formatOptions = [.withInternetDateTime]
        }
        
        guard let date = isoFormatter.date(from: isoDateString) else {
            return nil
        }
        
        // 2. 원하는 형식으로 시간만 출력
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // 24시간제로 시간과 분만 추출
        
        return timeFormatter.string(from: date)
    }
}
