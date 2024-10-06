//
//  SceneDelegate.swift
//  healthKitt
//
//  Created by brian on 6/9/24.
//

import BackgroundTasks
import UIKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("\(#function)")
        if let notificationResponse = connectionOptions.notificationResponse {
            let userInfo = notificationResponse.notification.request.content.userInfo
            // 알림 데이터 처리
            UserDefaults.standard.launchSensorData = true
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("\(#function)")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("\(#function)")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("\(#function)")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("\(#function)")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("\(#function)")
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "healthkit.com") // 설정한 identifier
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // 호출할 timeInterval을 1분으로 설정

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
