//
//  CustomSegmentedControl.swift
//  healthKitt
//
//  Created by brian on 9/7/24.
//

import Foundation
import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    // this color is coming theme library

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "#C5D0E3"))

                    Rectangle()
                        .fill(preselectedIndex == index ? Color.white : Color(hex: "#C5D0E3"))
                        .cornerRadius(20)
                        .padding(2)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselectedIndex = index
                                }
                            }
                }
                .overlay(
                    Text(options[index])
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(preselectedIndex == index ? Color(hex: "#0056E6") : .white)
                )
            }
        }
        .frame(height: 50)
        .cornerRadius(20)
    }
}
