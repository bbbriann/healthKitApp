//
//  CommonSelectButton.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import SwiftUI

struct CommonSelectButton: View {
    let title: String
    let titleColor: Color
    let bgColor: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.system(size: 14))
                .padding(.vertical, 18)
                .foregroundColor(titleColor)
            Spacer()
        }
        .background(bgColor)
        .frame(height: 56)
        .cornerRadius(28)
//        .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    }
}
