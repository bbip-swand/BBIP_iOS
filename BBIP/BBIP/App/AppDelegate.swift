//
//  AppDelegate.swift
//  BBIP
//
//  Created by 이건우 on 8/8/24.
//

import SwiftUI
import UIKit
import Moya
import LinkNavigator

import Firebase
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {
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
        
        #if DEBUG
        BBIPLogger.log("🌐 Using DEV Configuration...", level: .info, category: .default)
        #else
        BBIPLogger.log("🌐 Using PROD Configuration...", level: .info, category: .default)
        #endif
        
        BBIPLogger.log("🔧 Current AppEnvironment is \(AppEnvironment.current.rawValue)!", level: .info, category: .default)
        BBIPLogger.log(UserDefaultsManager.shared.getAccessToken() ?? "Access Token is empty", level: .debug, category: .model)
        
        return true
    }
    
    var appStateManager = AppStateManager()
    var navigator: LinkNavigator {
        LinkNavigator(
            dependency: AppDependency(appState: appStateManager),
            builders: AppRouterGroup().routers
        )
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
        guard let token = fcmToken else { return }
        handleFCMToken(token)
    }
    
    private func handleFCMToken(_ token: String) {
        UserDefaultsManager.shared.saveFCMToken(token: token)
        postFCMTokenToServer(token: token)
    }
    
    private func postFCMTokenToServer(token: String) {
        let provider = MoyaProvider<UserAPI>(plugins: [TokenPlugin(), LoggerPlugin()])
        provider.request(.postFCMToken(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let statusCode = response.statusCode
                    if (200..<300).contains(statusCode) {
                        BBIPLogger.log("FCM token successfully posted to the server", level: .info, category: .network)
                    } else {
                        BBIPLogger.log("Failed to post FCM token: \(statusCode)", level: .error, category: .network)
                    }
                }
            case .failure(let error):
                BBIPLogger.log("Error posting FCM token: \(error.localizedDescription)", level: .error, category: .network)
            }
        }
    }
}

// MARK: Swipe to pop
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
