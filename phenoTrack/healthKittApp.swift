//
//  healthKittApp.swift
//  healthKitt
//
//  Created by brian on 6/8/24.
//

import SwiftUI

enum StackViewType {
    case login
    case singup
    case signupComplete
}

@main
struct healthKittApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @State private var path: [StackViewType] = []
    
    @State private var isLoogedIn: Bool = UserDefaults.standard.accessToken != nil
    
    @StateObject private var viewModel = AppStateViewModel()
    
    init() {
        customozieNavigationBar()
        HealthKitService.shared.configure()
    }
    
    private func customozieNavigationBar() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoogedIn {
                    if viewModel.isLoading {
                        Spinner()
                    } else {
                        AppTabBarView()
                    }
                } else {
                    NavigationStack(path: $path) {
                        OnboardingView(path: $path)
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .loggedIn)) { notification in
                isLoogedIn = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .loggedOut)) { notification in
                isLoogedIn = false
            }
            .onReceive(NotificationCenter.default.publisher(for: .updateSenorData)) { notification in
                viewModel.fetchHealthDataAndProcess()
            }
        }
    }
}
