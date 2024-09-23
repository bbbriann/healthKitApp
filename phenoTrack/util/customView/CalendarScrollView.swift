//
//  CalendarScrollView.swift
//  healthKitt
//
//  Created by brian on 9/5/24.
//

import SwiftUI

struct CalendarScrollView: View {
    let nPanels = 15
    let panelSize: CGFloat = 48
    let gapSize: CGFloat = 0
    @State private var baseDate = Date.now
    
    @Binding var currentDate: Date
    let dayOfMonthFormatter = DateFormatter()
    let weekDayNameFormatter = DateFormatter()

    @State private var snappedDayOffset = 0
    @State private var draggedDayOffset = Double.zero

    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        dayOfMonthFormatter.dateFormat = "d"
        weekDayNameFormatter.dateFormat = "E"
        weekDayNameFormatter.locale = .init(identifier: "ko_KR")
    }

    private var positionWidth: CGFloat {
        CGFloat(panelSize + gapSize)
    }

    private func xOffsetForIndex(index: Int) -> Double {
        let midIndex = Double(nPanels / 2)
        var dIndex = (Double(index) - draggedDayOffset - midIndex).truncatingRemainder(dividingBy: Double(nPanels))
        if dIndex < -midIndex {
            dIndex += Double(nPanels)
        } else if dIndex > midIndex {
            dIndex -= Double(nPanels)
        }
        return dIndex * positionWidth
    }

    
    private func dayAdjustmentForIndex(index: Int) -> Int {
        let midIndex = nPanels / 2
        var dIndex = (index - snappedDayOffset - midIndex) % nPanels
        if dIndex < -midIndex {
            dIndex += nPanels
        } else if dIndex > midIndex {
            dIndex -= nPanels
        }
        return dIndex + snappedDayOffset
    }

    private func dateView(index: Int, halfFullWidth: CGFloat) -> some View {
        let xOffset = xOffsetForIndex(index: index)
        let dayAdjustment = dayAdjustmentForIndex(index: index)
        let dateToDisplay = Calendar.current.date(byAdding: .day, value: dayAdjustment, to: baseDate) ?? baseDate
        let isCenterDate = abs(xOffset) < positionWidth / 2
        if isCenterDate {
            DispatchQueue.main.async {
                self.currentDate = dateToDisplay
            }
        }
        return ZStack {
            VStack(alignment: .center, spacing: 10) {
                Text(weekDayNameFormatter.string(from: dateToDisplay))
                    .font(.system(size: 12))
                    .foregroundColor(isCenterDate ? .white : Color(hex: "#95BCF2"))
                Text(dayOfMonthFormatter.string(from: dateToDisplay))
                    .font(.system(size: isCenterDate ? 20 : 16, weight: .medium))
                    .foregroundColor(.white)
                if isCenterDate {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(width: isCenterDate ? 49 : 48, height: 72, alignment: .center)
            .background(isCenterDate ? .white.opacity(0.2) : .clear)
            .cornerRadius(isCenterDate ? 8 : 0)
        }
        .frame(width: panelSize, height: panelSize)
        .offset(x: xOffset)

        // Setting opacity helps to avoid blinks when switching sides
        .opacity(xOffset + positionWidth < -halfFullWidth || xOffset - positionWidth > halfFullWidth ? 0 : 1)
    }

    private var dragged: some Gesture {
        DragGesture()
            .onChanged() { val in
                draggedDayOffset = Double(snappedDayOffset) - (val.translation.width / positionWidth)
            }
            .onEnded { val in
                snappedDayOffset = Int(Double(snappedDayOffset) - (val.predictedEndTranslation.width / positionWidth).rounded())
                withAnimation(.easeInOut(duration: 0.15)) {
                    draggedDayOffset = Double(snappedDayOffset)
                }
            }
    }

    var body: some View {
        GeometryReader { proxy in
            let halfFullWidth = proxy.size.width / 3
            ZStack {
                ForEach(0..<nPanels, id: \.self) { index in
                    dateView(index: index, halfFullWidth: halfFullWidth)
                }
            }
            .gesture(dragged)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
