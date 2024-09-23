//
//  CalendarInputView.swift
//  healthKitt
//
//  Created by brian on 8/25/24.
//

import SwiftUI

struct CalendarInputView: View {
    @Binding var date: Date
    let image: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
            Text(date.toYYYYMMDDString())
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.vertical, 18)
            Spacer()
            Image("IcBlackArrowDown")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .frame(maxWidth: .infinity)
        .border(width: 1, edges: [.bottom],
                color: Color(hex:"#1068FD").opacity(0.1))
    }
}
