//
//  ViewExtension.swift
//  healthKitt
//
//  Created by brian on 8/20/24.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color, padding: CGFloat = 0) -> some View {
        overlay(EdgeBorder(width: width, edges: edges, padding: padding).foregroundColor(color))
    }
    
    @ViewBuilder public func overlayIf<T: View>(
      _ condition: Bool,
      _ content: T,
      alignment: Alignment = .center
    ) -> some View {
      if condition {
        self.overlay(content, alignment: alignment)
      } else {
        self
      }
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    var padding: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX + padding, y: rect.maxY - width, width: rect.width - padding * 2, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
