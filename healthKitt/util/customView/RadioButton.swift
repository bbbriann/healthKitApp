//
//  RadioButton.swift
//  healthKitt
//
//  Created by brian on 8/24/24.
//

import SwiftUI

struct RadioButton: View {
    @Binding private var isSelected: Bool
    private let label: String
    private var isDisabled: Bool = false
    
    init(isSelected: Binding<Bool>, label: String = "") {
      self._isSelected = isSelected
      self.label = label
    }
    
    // To support multiple options
    init<V: Hashable>(tag: V, selection: Binding<V?>, label: String = "") {
        self._isSelected = Binding(
            get: { selection.wrappedValue == tag },
            set: { _ in selection.wrappedValue = tag }
        )
        self.label = label
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
           circleView
           labelView
        }
        .contentShape(Rectangle())
        .onTapGesture { isSelected = true }
        .disabled(isDisabled)
    }
}

private extension RadioButton {
  @ViewBuilder var labelView: some View {
      if !label.isEmpty { // Show label if label is not empty
        Text(label)
          .foregroundColor(labelColor)
      }
  }
  
  @ViewBuilder var circleView: some View {
     Circle()
       .fill(innerCircleColor) // Inner circle color
       .padding(4)
       .overlay(
          Circle()
            .stroke(outlineColor, lineWidth: isSelected ? 4 : 1)
        ) // Circle outline
       .frame(width: 16, height: 16)
  }
}

private extension RadioButton {
   var innerCircleColor: Color {
      guard isSelected else { return Color.clear }
      if isDisabled { return Color.gray.opacity(0.6) }
      return .white
   }

   var outlineColor: Color {
      if isDisabled { return Color.gray.opacity(0.6) }
      return isSelected ? Color(hex: "#1068FD") : Color.gray
   }

   var labelColor: Color {
      return isDisabled ? Color(hex: "#D8DAE5") : Color.black
   }
}

extension RadioButton {
  func disabled(_ value: Bool) -> Self {
     var view = self
     view.isDisabled = value
     return view
  }
}
