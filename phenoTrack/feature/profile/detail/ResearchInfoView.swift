//
//  ResearchInfoView.swift
//  healthKitt
//
//  Created by brian on 8/27/24.
//

import SwiftUI

struct ResearchInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    HStack(alignment: .center, spacing: 16) {
                        Button {
                            NotificationCenter.default.post(Notification(name: .showTabBar))
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("IcBackBtnBlue")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        // Title/20px/Bold
                        Text("연구 관련 정보")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .padding(.horizontal, 24)
            contentView
                .cornerRadius(24)
            Spacer()
        }
        .background(.white)
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.post(Notification(name: .hideTabBar))
        }
        //        .padding(.horizontal, 24)
        /// content...
    }
    
    var contentView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                infoView
                
                Text("본 연구는 강남세브란스 병원에서 진행 되는 연구로 연구 종료 날짜에 어플이 종료 됩니다. 연구진의 지시사항을 잘 따라 주시면 감사하겠습니다. 문제가 발생했을 시 담당자에게 연락을 주시면 해결해 드리겠습니다 담당자 연락처: 010-2251-2380")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Body/16px/Bold
            Text("휴대폰 데이터를 이용한 섭식장애 증상\n예측 연구")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Text("총 연구 기간 (6주):")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#020C1C"))
                        
                        Text("2024.06.13 ~ 2024.07.25")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack(alignment: .center) {
                        Text("이용 기간 (3주):")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#020C1C"))
                        
                        Text("2024.06.13 ~ 2024.07.04")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text("이용 기간 동안 수집된 휴대폰 데이터와 설문을 바탕으로 섭식장애 증상을 예측 하는 연구를 진행합니다")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "#020C1C"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(hex: "#F1F5F9"))
        .cornerRadius(12)
    }
}
