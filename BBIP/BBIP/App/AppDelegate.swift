//
//  AppDelegate.swift
//  BBIP
//
//  Created by 이건우 on 8/8/24.
//

import SwiftUI
import UIKit
import Moya
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // MARK: - FCM
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // in app noti handle
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let token = fcmToken {
            UserDefaultsManager.shared.saveFCMToken(token: token)
            postFCMTokenToServer(token: token)
        }
    }
    
    private func postFCMTokenToServer(token: String) {
        let provider = MoyaProvider<UserAPI>(plugins: [TokenPlugin()])
        provider.request(.postFCMToken(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let statusCode = response.statusCode
                    if (200..<300).contains(statusCode) {
                        print("FCM token successfully posted to the server")
                    } else {
                        print("Failed to post FCM token: \(statusCode)")
                    }
                }
            case .failure(let error):
                print("Error posting FCM token: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Swipe to pop
extension UINavigationController: @retroactive UINavigationControllerDelegate, @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return viewControllers.count > 1
    }
}
