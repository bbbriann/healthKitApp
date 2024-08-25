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

enum SpecificType {
    case none
    case birth
}

enum Gender {
    case male
    case female
}

struct CommonInputView: View {
    @Binding var text: String
    let image: String
    var placeholder: String = ""
    var keyboardType = UIKeyboardType.default
    var isSecure: Bool = false
    
    var specificType: SpecificType = .none
    
    @State private var state: InputState = .default
    @State private var status: InputStatus = .default
    
    // birth only
    @Binding var gender: Gender?
    
    init(text: Binding<String>, image: String, placeholder: String = "",
         keyboardType: UIKeyboardType = UIKeyboardType.default, isSecure: Bool = false,
         specificType: SpecificType = .none, gender: Binding<Gender?> = .constant(.male)) {
        self._text = text
        self.image = image
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.specificType = specificType
        self._gender = gender
    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(imageColor)
                .frame(width: 24, height: 24)
                .opacity(text.isEmpty ? 0.5 : 1.0)
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
                switch specificType {
                case .none:
                    TextField("", text: $text)
                        .font(.system(size: 16))
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(Color(hex: "#020C1C"))
                                .opacity(0.5)
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 18)
                case .birth:
                    Text(text)
                        .font(.system(size: 16))
                        .padding(.vertical, 18)
                }
            }
            switch specificType {
            case .none:
                EmptyView()
            case .birth:
                Spacer()
                HStack(alignment: .center, spacing: 24) {
                    RadioButton(tag: .male, selection: $gender, label: "남자")
                    RadioButton(tag: .female, selection: $gender, label: "여자")
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .border(width: 1, edges: [.bottom],
                color: borderColor)
    }
    
    private var borderColor: Color {
        guard specificType == .none else {
            return Color(hex:"#1068FD").opacity(0.1)
        }
        if !text.isEmpty {
            return Color(hex:"#1068FD")
        } else {
            return Color(hex:"#1068FD").opacity(0.1)
        }
    }
    
    private var imageColor: Color? {
        guard specificType == .none else {
            return nil
        }
        if !text.isEmpty {
            return Color(hex:"#1068FD")
        } else {
            return nil
        }
    }
}
