//
//  RandomSurveyCardView.swift
//  healthKitt
//
//  Created by brian on 9/6/24.
//

import SwiftUI

enum RandomSurveyType {
    case `default`
    case time
    /// 폭식
    case voracity
    /// 메모
    case memo
}

enum RandomDataResult {
    case `default`(value: Int)
    case time(hour: Int, min: Int)
    /// 폭식
    case voracity(value: Int)
    /// 메모
    case memo(value: String)
}

struct RandomSurveyCardView: View {
    let cardIndex: Int
    let title: String
    var type: RandomSurveyType = .default
    let doneAction: (RandomDataResult) -> Void
    
    @State private var selectedIndex: Int? = nil
    @State private var memoText: String = ""
    @State private var showBottomSheet: Bool = false
    @State private var bottomSheetHeight: CGFloat = 0
    
    @Binding var time: String
    @Binding var memo: String
    
    /// Time
    @State private var selectedHour = 7
    @State private var selectedMinute = 0
    @State private var isAM = true
    
    @Binding private var modifyData: RandomDataResult?
    
    init(cardIndex: Int, title: String,
         modifyData: Binding<RandomDataResult?> = .constant(nil),
         type: RandomSurveyType = .default,
         time: Binding<String> = .constant(""),
         memo: Binding<String> = .constant(""),
         doneAction: @escaping (RandomDataResult) -> Void) {
        self.cardIndex = cardIndex
        self.title = title
        self.type = type
        self._time = time
        self._memo = memo
        self.doneAction = doneAction
        self._modifyData = modifyData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더
            HStack(alignment: .center, spacing: 12) {
                // 숫자
                HStack(alignment: .center, spacing: 4) {
                    Text((cardIndex + 1).toTwoDigits())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: "#1068FD"))
                .cornerRadius(8)
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if type == .voracity {
                    Button {
                        showBottomSheet.toggle()
                    } label: {
                        Image("IcQuestion")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 64, alignment: .center)
            .background(.white)
            .border(width: 1, edges: [.bottom], color: .black.opacity(0.1))
            .sheet(isPresented: $showBottomSheet, content: {
                // 연구자 승인 대기 시트
                VoracityInfoView(height: $bottomSheetHeight)
                    .presentationDetents([.height(370)])
                    .presentationDragIndicator(.visible)
            })
            
            // 바디
            VStack(alignment: .center) {
                switch type {
                case .default:
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(0..<5) { index in
                            Button {
                                doneAction(.default(value: index))
                                selectedIndex = index
                            } label: {
                                VStack(alignment: .center, spacing: 8) {
                                    VStack(alignment: .center, spacing: 8) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(hex: "#020C1C"))
                                            .frame(width: 20, height: 20, alignment: .center)
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, minHeight: 53,
                                           maxHeight: 53, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.5)
                                            .stroke(setSelectedColor(index: index), lineWidth: 1)
                                    )
                                    
                                    Text(getText(from: index))
                                        .font(.system(size: 10, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(hex: "#020C1C"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                case .time:
                    VStack(alignment: .leading, spacing: 32) {
                        Text("기억이 나지 않는다면 대략적으로 입력해 주세요")
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#020C1C"))
                            .frame(maxWidth: .infinity, alignment: .center)
                        TimePickerView(selectedHour: $selectedHour, selectedMinute: $selectedMinute, isAM: $isAM)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                case .voracity:
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(0..<3) { index in
                            Button {
                                doneAction(.voracity(value: index))
                                selectedIndex = index
                            } label: {
                                VStack(alignment: .center, spacing: 8) {
                                    VStack(alignment: .center, spacing: 8) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(hex: "#020C1C"))
                                            .frame(width: 20, height: 20, alignment: .center)
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, minHeight: 53,
                                           maxHeight: 53, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.5)
                                            .stroke(setSelectedColor(index: index), lineWidth: 1)
                                    )
                                    
                                    Text(getVoracityText(from: index))
                                        .font(.system(size: 10, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(hex: "#020C1C"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                case .memo:
                    TextEditorWithPlaceholderView(placeholder: "메모 입력",text: $memoText)
                        .padding(20)
                        .border(width: 1, edges: [.bottom], color: Color(hex: "#1068FD").opacity(0.1), padding: 20)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .onChange(of: memoText, { old, new in
            doneAction(.memo(value: new))
        })
        .onChange(of: selectedHour, { old, new in
            let (hour, min) = convertTo24Hour(hour: selectedHour, minute: selectedMinute, isAM: isAM)
            doneAction(.time(hour: hour, min: min))
        })
        .onChange(of: selectedMinute, { old, new in
            let (hour, min) = convertTo24Hour(hour: selectedHour, minute: selectedMinute, isAM: isAM)
            doneAction(.time(hour: hour, min: min))
        })
        .onChange(of: isAM, { old, new in
            let (hour, min) = convertTo24Hour(hour: selectedHour, minute: selectedMinute, isAM: isAM)
            doneAction(.time(hour: hour, min: min))
        })
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(12)
        .onAppear {
            if let modifyData {
                switch modifyData {
                case .default(let value):
                    selectedIndex = value
                case .time(let hour, let min):
                    selectedHour = hour
                    selectedMinute = min
                case .voracity(let value):
                    selectedIndex = value
                default: do {}
                }
            }
        }
    }
    
    private func setSelectedColor(index: Int) -> Color {
        print("[TEST] selectedIndex \(selectedIndex) index \(index)")
        if let selectedIndex, selectedIndex == index {
            return Color(hex: "#1068FD")
        } else {
            return .black.opacity(0.1)
        }
    }
    
    private func getText(from index: Int) -> String {
        switch index {
        case 0:
            return "전혀 그렇지 않다"
        case 1:
            return "그렇지 않다"
        case 2:
            return "보통이다"
        case 3:
            return "그렇다"
        case 4:
            return "매우 그렇다"
        default:
            return ""
        }
    }
    
    private func getVoracityText(from index: Int) -> String {
        switch index {
        case 0:
            return "아니다"
        case 1:
            return "모르겠다"
        case 2:
            return "그렇다"
        default:
            return ""
        }
    }
    
    private func convertTo24Hour(hour: Int, minute: Int, isAM: Bool) -> (hour: Int, minute: Int) {
        var hour24 = hour
        
        if isAM {
            // AM일 경우 12시는 0시로 변환
            if hour == 12 {
                hour24 = 0
            }
        } else {
            // PM일 경우 12시는 그대로 유지하고, 나머지는 12시간 더함
            if hour != 12 {
                hour24 = hour + 12
            }
        }
        
        return (hour: hour24, minute: minute)
    }
}

struct VoracityInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var height: CGFloat
    
    var body: some View {
        VStack {
            Text("폭식 했다고 생각하시나요?")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            Text("폭식이란")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 12)
            
            Text("단시간(2시간) 내에 많은 양의 음식을 먹고,\n먹는 것에 대해서 조절 능력의 상실감을 느끼는 경우 (예, 먹는 것을 멈출 수 없거나 얼마나 많이 먹을 지 조절 할 수 없는 느낌)를 말합니다.")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 48)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                CommonSelectButton(title: "확인",
                                   titleColor: .white,
                                   bgColor: Color(hex: "#1068FD"))
            }
        }
        .padding(.horizontal, 24)
        .readSize { calculatedHeight in
            height = calculatedHeight.height
        }
    }
}
