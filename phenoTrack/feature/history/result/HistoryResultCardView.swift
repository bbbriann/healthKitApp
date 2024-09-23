//
//  HistoryResultCardView.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import Charts
import SwiftUI

struct HistoryResultCardView: View {
    // Example data points
    @State private var surveyData: [MoodSurveyData] = [
        MoodSurveyData(category: "보통이거나 아니라고 표현한 건", count: 3, percentage: 50, color: Color.blue),
        MoodSurveyData(category: "그렇다 혹은 매우 그렇다고 표현한 건", count: 3, percentage: 50, color: Color.red)
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("음식을 먹기 전에 기분이 좋지 않았나요?")
                .font(.headline)
                .padding(.top, 16)
            Text("(지루하거나 화나거나 스트레스 받는 등)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 8)

            HStack {
                Chart {
                    ForEach(surveyData) { data in
                        SectorMark(
                            angle: .value("Percentage", data.percentage),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(data.color)
                    }
                }
                .chartLegend(.hidden)
                .frame(width: 120, height: 120)
                
                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(surveyData) { data in
                        HStack {
                            Circle()
                                .fill(data.color)
                                .frame(width: 12, height: 12)
                            Text("\(data.category): \(data.count)건 (\(Int(data.percentage))%)")
                                .font(.footnote)
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}
