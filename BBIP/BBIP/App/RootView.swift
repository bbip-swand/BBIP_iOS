//
//  ContentView.swift
//  BBIP
//
//  Created by 이건우 on 7/30/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        Group {
            switch appStateManager.state {
            case .onboarding:
                NavigationStack {
                    OnboardingView()
                }
                
            case .infoSetup:
                NavigationStack {
                    UserInfoSetupView()
                }
                
            case .startGuide:
                NavigationStack {
                    StartGuideView()
                }
                
            case .home:
                NavigationStack(path: $appStateManager.path) {
                    MainHomeView()
                }
            }
        }
        .preferredColorScheme(appStateManager.colorScheme)
        .environmentObject(appStateManager)
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .overlay(
            Group {
                if let data = appStateManager.deepLinkAlertData {
                    JoinStudyCustomAlert(
                        appState: appStateManager,
                        inviteData: data
                    )
                    .opacity(appStateManager.showDeepLinkAlert ? 1 : 0)
                }
            }
        )
        .alert(isPresented: $appStateManager.showJoinFailAlert) {
            Alert(
                title: Text("가입 실패"),
                message: Text("이미 가입된 스터디입니다"),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard UserDefaaultsManager.shared.checkLoginStatus() else { return }
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
                appStateManager.setDeepLinkAlertData(deepLinkAlertData)
                appStateManager.showDeepLinkAlert = true
            }
        }
    }
}


enum path: String {
    case root = "Root"
}
