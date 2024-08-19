//
//  AppDelegate.swift
//  healthKitt
//
//  Created by brian on 6/9/24.
//

import BackgroundTasks
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "healthkit.com", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask) // 실제로 수행할 코드가 구현된 매서드
        }
        print("calleD??")
        requestNotificationAuthorization()
        
        return true
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        NSLog("백그라운드 호출 기록")
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        let config = URLSessionConfiguration.background(withIdentifier: "healthkit.com")
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        let dataTask = session.dataTask(with: URLRequest(url: URL(string: "https://f872-119-194-253-20.ngrok-free.app/")!))
        session.dataTask(with: URLRequest(url: URL(string: "https://f872-119-194-253-20.ngrok-free.app/")!)) { data, res, error in
            task.setTaskCompleted(success: true)
        }
        dataTask.resume()
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
    // 위에서 정의한 함수 추가
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error)")
            }
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
