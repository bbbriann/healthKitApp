//
//  CommonInputView.swift
//  healthKitt
//
//  Created by brian on 8/20/24.
//

import SwiftUI

enum InputState {
    case `default`
    case typing
    case typingDone
}

enum InputStatus {
    case `default`
    case error
    case success
}

struct CommonInputView: View {
    @Binding var text: String
    let image: String
    let placeholder: String
    var keyboardType = UIKeyboardType.default
    var isSecure: Bool = false
    
    @State private var state: InputState = .default
    @State private var status: InputStatus = .default
    
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
                .opacity(0.5)
            if isSecure {
                SecureField("", text: $text)
                    .font(.system(size: 16))
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(Color(hex: "#020C1C"))
                            .opacity(0.5)
                            .font(.system(size: 16))
                    }
                    .padding(.vertical, 18)
            } else {
                TextField("", text: $text)
                    .font(.system(size: 16))
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(Color(hex: "#020C1C"))
                            .opacity(0.5)
                            .font(.system(size: 16))
                    }
                    .padding(.vertical, 18)
            }
        }
        .border(width: 1, edges: [.bottom],
                color: Color(hex:"#1068FD").opacity(0.1))
    }
}
