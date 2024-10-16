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
    case pwEdit
}

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
}

struct CommonInputView: View {
    @Binding var text: String
    let image: String
    var placeholder: String = ""
    var keyboardType = UIKeyboardType.default
    var isSecure: Bool = false
    
    var specificType: SpecificType = .none
    
    var needNoFocus: Bool = false
    
    @State private var state: InputState = .default
    private var status: InputStatus = .default
    
    // birth only
    @Binding var gender: Gender?
    
    init(text: Binding<String>, image: String, placeholder: String = "",
         keyboardType: UIKeyboardType = UIKeyboardType.default, isSecure: Bool = false,
         specificType: SpecificType = .none, gender: Binding<Gender?> = .constant(.male),
         needNoFocus: Bool = false, status: InputStatus = .default) {
        self._text = text
        self.image = image
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.specificType = specificType
        self._gender = gender
        self.status = status
        self.needNoFocus = needNoFocus
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
                    .foregroundColor(Color(hex: "#020C1C"))
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(Color(hex: "#020C1C"))
                            .opacity(0.5)
                            .font(.system(size: 16))
                    }
                    .padding(.vertical, 18)
                    .multilineTextAlignment(.leading)
                if specificType == .pwEdit {
                    Spacer()
                }
            } else {
                switch specificType {
                case .none:
                    TextField("", text: $text)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(Color(hex: "#020C1C"))
                                .opacity(0.5)
                                .font(.system(size: 16))
                        }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(keyboardType)
                        .padding(.vertical, 18)
                        .toolbar {
                            if keyboardType == .phonePad {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("완료") {
                                        hideKeyboard()
                                    }
                                }
                            }
                        }
                case .birth:
                    Text(text)
                        .foregroundColor(Color(hex: "#020C1C"))
                        .font(.system(size: 16))
                        .padding(.vertical, 18)
                default:
                    EmptyView()
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
            case .pwEdit:
                Spacer()
                Image("IcEdit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
        }
        .frame(maxWidth: .infinity)
        .border(width: 1, edges: [.bottom],
                color: borderColor)
    }
    
    // 키보드 숨기는 함수
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var borderColor: Color {
        if status == .error {
            return Color(hex: "#DA072D")
        }
        guard specificType == .none else {
            return Color(hex:"#1068FD").opacity(0.1)
        }
        guard !needNoFocus else {
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
            return Color(hex:"#1068FD")
        }
        guard !needNoFocus else {
            return Color(hex: "#020C1C")
        }
        if !text.isEmpty {
            return Color(hex:"#1068FD")
        } else {
            return Color(hex: "#020C1C")
        }
    }
}
