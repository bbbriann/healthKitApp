//
//  HomeView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Pheno")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Text("Track")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color.mainColor)
                    }
                    HStack(spacing: 0) {
                        Text("좋은 아침이에요, ")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Text("신보경님")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "##0056E6"))
                        Spacer()
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        HStack(alignment: .center, spacing: 10) {
                            Text("아직 데이터가 없습니다")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#020C1C"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            HStack(alignment: .center, spacing: 12) {
                                Image("IcAlarm")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("알림")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "#020C1C"))
                            }
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 4) {
                                Image("IcInfo")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                // Body/12px/Medium
                                Text("승인 대기중")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(height: 24, alignment: .leading)
                            .background(Color(hex: "#1068FD"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56, alignment: .center)
                        .background(Color(red: 0.88, green: 0.94, blue: 1))
                        
                        HStack(alignment: .center, spacing: 0) {
                            Image("IcHomeNoData")
                                .resizable()
                                .frame(width: 140, height: 140)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Body/16px/Medium
                        Text("어플리케이션을 이용하시기 위해서는 연구자\n승인이 필요합니다.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "#020C1C"))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(16)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
    }
}
