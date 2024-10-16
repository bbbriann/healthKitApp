//
//  HistoryAddButtonView.swift
//  healthKitt
//
//  Created by brian on 9/5/24.
//

import SwiftUI

struct HistoryAddButtonView: View {
    var body: some View {
        HStack {
            Color.clear
                .frame(width: 44, height: 56)
            Spacer()
            Text("새로 추가 하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            Spacer()
            HStack(alignment: .center, spacing: 10) {
                Image("IcPlusWhite")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .background(.white.opacity(0.2))
            .cornerRadius(16)
            Color.clear
                .frame(width: 12, height: 56)
        }
        .background(Color(hex: "#1068FD"))
        .padding(.vertical, 12)
        .frame(minWidth: 56, maxWidth: .infinity, maxHeight: 56)
        .cornerRadius(12)
    }
}
