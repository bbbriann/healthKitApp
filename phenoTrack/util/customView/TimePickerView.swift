//
//  TimePickerView.swift
//  healthKitt
//
//  Created by brian on 9/6/24.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var isAM: Bool
    @State private var showHourPicker = false
    @State private var showMinutePicker = false

    private let hours = Array(1...12)
    private let minutes = Array(0...59)
    
    var body: some View {
        HStack(spacing: 16) {
            // Hour Button
            Button(action: {
                showHourPicker.toggle()
            }) {
                Text(String(format: "%02d", selectedHour))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(width: 60, height: 60)
                    .background(Color(hex: "#F1F5F9"))
                    .cornerRadius(12)
            }
            .sheet(isPresented: $showHourPicker) {
                Picker("Select Hour", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text(String(format: "%02d", hour))
                            .font(.system(size: 24, weight: .bold))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxHeight: 200)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
            }

            // Minute Button
            Button(action: {
                showMinutePicker.toggle()
            }) {
                Text(String(format: "%02d", selectedMinute))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(width: 60, height: 60)
                    .background(Color(hex: "#F1F5F9"))
                    .cornerRadius(12)
            }
            .sheet(isPresented: $showMinutePicker) {
                Picker("Select Minute", selection: $selectedMinute) {
                    ForEach(minutes, id: \.self) { minute in
                        Text(String(format: "%02d", minute))
                            .font(.system(size: 24, weight: .bold))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxHeight: 200)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
            }

            // AM/PM Toggle
            HStack(spacing: 4) {
                Button(action: {
                    isAM = true
                }) {
                    Text("AM")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .frame(width: 33, height: 22)
                        .background(isAM ? Color.white : Color(hex: "#F1F5F9"))
                        .cornerRadius(8)
                        .shadow(color: isAM ? .black.opacity(0.14) : Color.clear, radius: 2.2, x: 0, y: 2)
                }

                Button(action: {
                    isAM = false
                }) {
                    Text("PM")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .frame(width: 33, height: 22)
                        .background(!isAM ? Color.white : Color(hex: "#F1F5F9"))
                        .cornerRadius(8)
                        .shadow(color: !isAM ? .black.opacity(0.14) : Color.clear, radius: 2.2, x: 0, y: 2)
                }
            }
        }
        .padding()
    }
}
