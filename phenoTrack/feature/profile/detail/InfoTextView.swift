//
//  PrivacyPolicyView.swift
//  phenoTrack
//
//  Created by brian on 9/28/24.
//

import SwiftUI

struct InfoTextView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var fileName: String
    var title: String
    @State private var privacyPolicyText: String = ""
    @State private var isLoading: Bool = true
    
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
                        Text(title)
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
            DispatchQueue.global().async {
                loadPrivacyPolicy()
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
            
        }
    }
    
    var contentView: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(2) // 크기를 2배로 확대
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .frame(width: 100, height: 100)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(privacyPolicyText)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#020C1C"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        //                    TextEditor(text: .constant(LongText.privacyText))
                        //                        .font(.system(size: 16))
                        //                        .foregroundColor(Color(hex: "#020C1C"))
                        //                        .frame(maxWidth: .infinity, alignment: .leading)
                        //                        .lineLimit(nil)
                        //                        .fixedSize(horizontal: false, vertical: true)
                        //                        .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
    
    private func loadPrivacyPolicy() {
            if let filepath = Bundle.main.path(forResource: fileName, ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    privacyPolicyText = contents
                } catch {
                    print("Failed to load the privacy policy text file.")
                }
            }
        }
}
