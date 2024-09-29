//
//  ProfileView.swift
//  healthKitt
//
//  Created by brian on 8/25/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var path: [ProfileViewStack] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @Binding var showLogoutAlert: Bool
    @State private var user: UserInfo = UserDefaults.standard.userInfo ?? .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    HStack {
                        // Title/20px/Bold
                        Text("계정")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            showLogoutAlert.toggle()
                        } label: {
                            Image("IcLogout")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .padding(.horizontal, 24)
                Spacer(minLength: 61)
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .cornerRadius(24)
                        .rotationEffect(Angle(degrees: -4))
                    contentView
                        .cornerRadius(24)
                }
            }
            .background(Color(hex: "#1068FD"))
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: ProfileViewStack.self) { viewType in
                switch viewType {
                case .profile:
                    EmptyView()
                case .researchInfo:
                    ResearchInfoView()
                case .sensitiveInfo:
                    InfoTextView(fileName: "sensitiveInfo",
                                 title: "민감정보수집이용 동의서")
                case .privacyPolicy:
                    InfoTextView(fileName: "privacyPolicy",
                                 title: "개인정보취급방침")
                case .editProfile:
                    ProfileEditView(path: $path)
                case .changePassword:
                    ChangePWView(path: $path)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .profileViewRefresh)) { notification in
            if let userInfo = UserDefaults.standard.userInfo {
                user = userInfo
            }
        }
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackButtonView()
        }
    }
    
    var contentView: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 32) {
                    infoView
                    settingView
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .background(Color(hex: "#F1F5F9"))
        .cornerRadius(24)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("내 정보")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
                Button {
                    path.append(.editProfile)
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Image("IcEdit")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("편집하다")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.white)
                    .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // 내 정보
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    // Body/14px/Medium
                    Text("이름")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                    Spacer()
                    // Alternative Views and Spacers
                    Text(userName)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#020C1C"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .center)
                .border(width: 1, edges: [.bottom], color: .black.opacity(0.05), padding: 20)
                
                HStack(alignment: .center) {
                    // Body/14px/Medium
                    Text("휴대폰 번호")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                    Spacer()
                    // Alternative Views and Spacers
                    Text(phoneNumber)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#020C1C"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .center)
                .border(width: 1, edges: [.bottom], color: .black.opacity(0.05), padding: 20)
                
                HStack(alignment: .center) {
                    // Body/14px/Medium
                    Text("이메일")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#020C1C"))
                    Spacer()
                    // Alternative Views and Spacers
                    Text(user.email ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#020C1C"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    var settingView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Text("설정")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // 내 정보
            VStack(alignment: .center, spacing: 0) {
                Button {
                    path.append(.privacyPolicy)
                } label: {
                    HStack(alignment: .center) {
                        // Body/14px/Medium
                        Text("개인정보취급방침")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Spacer()
                        // Alternative Views and Spacers
                        Image("IcRightArrowBlue")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .border(width: 1, edges: [.bottom], color: .black.opacity(0.05), padding: 20)
                }
                Button {
                    path.append(.sensitiveInfo)
                } label: {
                    HStack(alignment: .center) {
                        // Body/14px/Medium
                        Text("민감정보수집이용 동의서")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Spacer()
                        // Alternative Views and Spacers
                        Image("IcRightArrowBlue")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .border(width: 1, edges: [.bottom], color: .black.opacity(0.05), padding: 20)
                }
                
                Button {
                    path.append(.researchInfo)
                } label: {
                    HStack(alignment: .center) {
                        // Body/14px/Medium
                        Text("연구 관련 정보")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#020C1C"))
                        Spacer()
                        // Alternative Views and Spacers
                        Image("IcRightArrowBlue")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private var userName: String {
        let name = (user.first_name ?? "")
        return name
    }
    
    private var phoneNumber: String {
        let value = (user.profile?.mobile_number ?? "")
        return value
    }
}
