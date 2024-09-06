//
//  DiaryView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import SwiftUI

struct DiaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var selectedDate = Date()
    @State private var hasCalendarButtonPressed = false
    @State private var showRandomSurveyView: Bool = false
    @State private var showDiaryResultView: Bool = false
    private var calendar = Calendar.current
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private var dataList = ["09:35","12:30","14:25","17:12","20:32"]
    
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("식사 일기")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
//                    Button {
//                        hasCalendarButtonPressed.toggle()
//                    } label: {
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
//                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .padding(.horizontal, 24)
            
//            if hasCalendarButtonPressed {
//                CalenderView(clickedCurrentMonthDates: $selectedDate,
//                             hasCalendarButtonPressed: $hasCalendarButtonPressed)
//                    .padding(.top, 30)
//            }
            
            CalendarScrollView(currentDate: $selectedDate)
                .padding(.horizontal, 24)
                .frame(height: 72)
            Spacer(minLength: 61)
            ZStack {
                contentView
                    .cornerRadius(24)
            }
            
            NavigationLink(destination: DiaryResultView(), isActive: $showDiaryResultView) {
                EmptyView()
            }
            
            NavigationLink(destination: DiaryRandomSurveyView(), isActive: $showRandomSurveyView) {
                EmptyView()
            }
        }
        .background(Color(hex: "#1068FD"))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
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
                    ForEach(0..<dataList.count) { index in
                        Button {
                            showDiaryResultView.toggle()
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
                    Button {
                        showRandomSurveyView.toggle()
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
