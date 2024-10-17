//
//  AppDelegate.swift
//  healthKitt
//
//  Created by brian on 6/9/24.
//

import BackgroundTasks
import UIKit
import UserNotifications

import Firebase

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "healthkit.com", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask) // 실제로 수행할 코드가 구현된 매서드
        }
        print("calleD??")
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
        
        application.registerForRemoteNotifications()
        // FirebaseMessaging
        Messaging.messaging().delegate = self
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
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // 알림 데이터 처리
        print("[TEST] \(#function) userInfo : \(userInfo)")
        NotificationCenter.default.post(Notification(name: .updateSenorData))
        completionHandler()
    }
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        let token = String(describing: fcmToken)
        UserDefaults.standard.fcmToken = token
    }
    
}
