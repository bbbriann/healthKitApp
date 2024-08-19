//
//  OnboardingView.swift
//  healthKitt
//
//  Created by brian on 6/8/24.
//

import HealthKit
import UserNotifications
import SwiftUI

struct OnboardingView: View {
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
            Image("IcOnboarding")
                .resizable()
                .frame(height: UIScreen.main.bounds.width - 48)
            VStack(spacing: 16) {
                NavigationLink(destination: SignUpView()) {
                    CommonSelectButton(title: "회원가입",
                                       titleColor: Color.mainColor,
                                       bgColor: Color.mainColor.opacity(0.18))
                }
                
                NavigationLink(destination: LoginView()) {
                    CommonSelectButton(title: "로그인",
                                       titleColor: Color.white,
                                       bgColor: Color.mainColor)
                }

                HStack(alignment: .center, spacing: 48) {
                    HStack(alignment: .center, spacing: 4) {
                        Text("비밀번호 재설정")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Image("IcRightArrow")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    HStack(alignment: .center, spacing: 4) {
                        Text("아이디 찾기")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#0056E6"))
                        Image("IcRightArrow")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(hex: "#0056E6"))
                            .frame(width: 16, height: 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .background(Color.white)
        
    }
}
