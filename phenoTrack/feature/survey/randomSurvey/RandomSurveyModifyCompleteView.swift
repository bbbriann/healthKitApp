//
//  RandomSurveyModifyCompleteView.swift
//  phenoTrack
//
//  Created by brian on 10/2/24.
//

import SwiftUI

struct RandomSurveyModifyCompleteView: View {
    @Binding var path: [HistoryViewStack]
    var body: some View {
        VStack {
            Spacer(minLength: 24)
            HStack(spacing: 0) {
                Text("Pheno")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Text("Track")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.mainColor)
            }
            Spacer()
            VStack(alignment: .center, spacing: 48) {
                VStack(alignment: .center, spacing: 24) {
                    GifImage("complete")
                        .frame(width: 180, height: 180)
                    // Title/20px/Medium
                    Text("설문 수정 완료")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                      .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity)
                
//                NavigationLink(destination: LoginView()) {
                Button {
                    path.removeLast(path.count)
                    NotificationCenter.default.post(Notification(name: .showTabBar))
                } label: {
                    CommonSelectButton(title: "확인",
                                       titleColor: Color.white,
                                       bgColor: Color.mainColor)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .background(Color.white)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        
    }
}
