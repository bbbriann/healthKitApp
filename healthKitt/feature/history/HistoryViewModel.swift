//
//  HistoryViewModel.swift
//  healthKitt
//
//  Created by brian on 9/8/24.
//

import SwiftUI

struct MoodData: Identifiable {
    let id = UUID()
    let time: Date
    let value: Double
    let category: String
}

///  파이 차트 데이터
struct MoodSurveyData: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
    let percentage: Double
    let color: Color
}

final class HistoryViewModel: ObservableObject {
    @Published var moodData: [MoodData] = [
        // Example data points for each category
        MoodData(time: Date().addingTimeInterval(-3600 * 14), value: 2, category: "음식 생각"),
        MoodData(time: Date().addingTimeInterval(-3600 * 12), value: 3, category: "기분"),
        MoodData(time: Date().addingTimeInterval(-3600 * 10), value: 1, category: "스트레스"),
        MoodData(time: Date().addingTimeInterval(-3600 * 8), value: 5, category: "음식 생각"),
        MoodData(time: Date().addingTimeInterval(-3600 * 6), value: 3, category: "기분"),
        MoodData(time: Date().addingTimeInterval(-3600 * 4), value: 2, category: "스트레스"),
        // ... Add more data points for a complete chart
    ]
    
    @Published var surveyData: [MoodSurveyData] = [
            MoodSurveyData(category: "보통이거나 아니라고 표현한 건", count: 3, percentage: 50, color: Color.blue),
            MoodSurveyData(category: "그렇다 혹은 매우 그렇다고 표현한 건", count: 3, percentage: 50, color: Color.red)
        ]
    
    init() { }    
}
