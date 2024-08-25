//
//  AppTabBarView.swift
//  healthKitt
//
//  Created by brian on 8/25/24.
//

import SwiftUI

struct AppTabBarView: View {
    enum Tab {
        case home, diary, history, profile
    }
    
    @State private var selected: Tab = .home
    
    var body: some View {
        ZStack {
            TabView(selection: $selected) {
                Group {
                    NavigationStack {
                        HomeView()
                    }
                    .tag(Tab.home)
                    
                    NavigationStack {
                        DiaryView()
                    }
                    .tag(Tab.diary)
                    
                    NavigationStack {
                        HistoryView()
                    }
                    .tag(Tab.history)
                    
                    NavigationStack {
                        ProfileView()
                    }
                    .tag(Tab.profile)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            
            VStack {
                Spacer()
                tabBar
            }
        }
    }
    
    var tabBar: some View {
        HStack {
            Spacer()
            Button {
                selected = .home
            } label: {
                if selected == .home {
                    HStack(alignment: .center, spacing: 8) {
                        Image("IcHomeSelected")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("홈페이지")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .frame(width: 53)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 12)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#1068FD"))
                    .cornerRadius(24)
                } else {
                    Image("IcHome")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundStyle(selected == .home ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .diary
            } label: {
                if selected == .diary {
                    HStack(alignment: .center, spacing: 8) {
                        Image("IcDiarySelected")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                        Text("다이어리")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#1068FD"))
                    .cornerRadius(24)
                } else {
                    Image("IcDiary")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundStyle(selected == .diary ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .history
            } label: {
                if selected == .history {
                    HStack(alignment: .center, spacing: 8) {
                        Image("IcHistorySelected")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                        Text("이력")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#1068FD"))
                    .cornerRadius(24)
                } else {
                    Image("IcHistory")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundStyle(selected == .history ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .profile
            } label: {
                if selected == .profile {
                    HStack(alignment: .center, spacing: 8) {
                        Image("IcProfileSelected")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                        Text("프로필")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#1068FD"))
                    .cornerRadius(24)
                } else {
                    Image("IcProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundStyle(selected == .profile ? Color.accentColor : Color.primary)
            Spacer()
        }
        .padding()
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
}

struct AView: View {
    var body: some View {
        Text("View A")
    }
}

struct BView: View {
    var body: some View {
        Text("View B")
    }
}

struct CView: View {
    var body: some View {
        Text("View C")
    }
}
