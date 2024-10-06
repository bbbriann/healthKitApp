//
//  TextEditorWithPlaceholderView.swift
//  healthKitt
//
//  Created by brian on 9/7/24.
//

import SwiftUI

struct TextEditorWithPlaceholderView: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                        .foregroundColor(Color(hex: "#020C1C"))
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(minHeight: 50, maxHeight: 100)
                    .background(Color.white)
                    .opacity(text.isEmpty ? 0.85 : 1)
                    .scrollContentBackground(.hidden)
                Spacer()
            }
        }
    }
}
