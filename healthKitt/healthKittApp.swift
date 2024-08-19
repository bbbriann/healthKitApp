//
//  healthKittApp.swift
//  healthKitt
//
//  Created by brian on 6/8/24.
//

import SwiftUI

@main
struct healthKittApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    init() {
        customozieNavigationBar()
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
            NavigationStack {
                OnboardingView()
            }
        }
    }
}
