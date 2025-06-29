//
//  BBIPApp.swift
//  BBIP
//
//  Created by 이건우 on 7/30/24.
//

import SwiftUI
import LinkNavigator

@main
struct BBIPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var showSplash = true

    var navigator: LinkNavigator {
        appDelegate.navigator
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                navigator
                    .launch(paths: [BBIPMatchPath.initialRoute.capitalizedPath], items: [:])
                    .edgesIgnoringSafeArea(.all)
                    .onOpenURL { url in
                        handleDeepLink(url)
                    }
                
                if showSplash {
                    SplashView() { showSplash = false }
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: showSplash)
        }
    }
}

extension BBIPApp {
    private func handleDeepLink(_ url: URL) {
        guard UserDefaultsManager.shared.checkLoginStatus() else { return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.host == "inviteStudy" {
            if let queryItems = urlComponents?.queryItems {
                let deepLinkAlertData = DeepLinkAlertData(
                    studyId: queryItems.first(where: { $0.name == "studyId" })?.value ?? "",
                    imageUrl: queryItems.first(where: { $0.name == "imageUrl" })?.value,
                    studyName: queryItems.first(where: { $0.name == "studyName" })?.value ?? "",
                    studyDescription: queryItems.first(where: { $0.name == "studyDescription" })?.value
                )
                print(deepLinkAlertData)
//                appStateManager.setDeepLinkAlertData(deepLinkAlertData)
//                appStateManager.showDeepLinkAlert = true
            }
        }
    }
}
