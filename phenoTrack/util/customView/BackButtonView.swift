//
//  BackButtonView.swift
//  healthKitt
//
//  Created by brian on 8/20/24.
//

import SwiftUI

struct BackButtonView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Image("IcBackButton")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .frame(width: 44, height: 44)
    }
}
