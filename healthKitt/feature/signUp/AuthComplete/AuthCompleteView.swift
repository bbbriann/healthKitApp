//
//  AuthCompleteView.swift
//  healthKitt
//
//  Created by brian on 8/25/24.
//

import SwiftUI

struct AuthCompleteView: View {
    @Binding var path: [StackViewType]
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
                    Text("회원 가입 완료")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                      .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity)
                
//                NavigationLink(destination: LoginView()) {
                Button {
                    path.removeLast(path.count)
                } label: {
                    CommonSelectButton(title: "로그인",
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
