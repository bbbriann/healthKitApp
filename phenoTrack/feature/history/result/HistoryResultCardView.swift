//
//  HistoryResultCardView.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import Charts
import SwiftUI

struct HistoryResultCardView: View {
    let title: String
    let description: String
    let positiveCount: Int
    let totalResponses: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .padding(.top, 16)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                // 차트
                Chart {
                    // 부정적 응답 (예: "보통이거나 아니라고 표현한 건")
                    SectorMark(
                        angle: .value("Percentage", negativePercentage),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(Color.blue)
                    
                    // 긍정적 응답 (예: "그렇다 혹은 매우 그렇다고 표현한 건")
                    SectorMark(
                        angle: .value("Percentage", positivePercentage),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(Color.red)
                }
                .chartLegend(.hidden)
                .frame(width: 120, height: 120)
                
                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                        Text("보통이거나 아니라고 표현한 건: \(negativeCount)건 (\(Int(negativePercentage))%)")
                            .font(.footnote)
                    }
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                        Text("그렇다 혹은 매우 그렇다고 표현한 건: \(positiveCount)건 (\(Int(positivePercentage))%)")
                            .font(.footnote)
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
    
    // 부정적 응답의 개수
    private var negativeCount: Int {
        totalResponses - positiveCount
    }
    
    // 긍정적 응답의 비율
    private var positivePercentage: Double {
        guard totalResponses != 0 else {
            return 0
        }
        return Double(positiveCount) / Double(totalResponses) * 100
    }
    
    // 부정적 응답의 비율
    private var negativePercentage: Double {
        guard totalResponses != 0 else {
            return 0
        }
        return Double(negativeCount) / Double(totalResponses) * 100
    }
}
