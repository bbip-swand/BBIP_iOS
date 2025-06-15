//
//  LegacyStartFlow.swift.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import Foundation
import SwiftUI

enum AppState: Hashable {
    case splash
    case onboarding
    case infoSetup
    case startGuide
    case home
    
    var rawValue: String {
        switch self {
        case .splash:
            return "spash"
        case .onboarding:
            return "onboarding"
        case .infoSetup:
            return "infoSetup"
        case .startGuide:
            return "startGuide"
        case .home:
            return "home"
        }
    }
}

enum MainHomeViewDestination: Hashable {
    case notice
    case mypage
    
    // MARK: - UserHome
    case startSIS       // sis startPoint
    case SIS            // study into setup
    case completeSIS    // sis endPoing
    
    case entercode(remainingTime: Int, studyId: String, studyName: String)
    
    // MARK: - StudyHome
    case createCode(studyId: String, session: Int)
    case showPostingList(studyId: String, postData: RecentPostVO, weeklyStudyContent: [String])
    
    // MARK: - StudyHome
    case setLocation(prevLocation:String, studyId: String, session: Int)
}

final class AppStateManager: ObservableObject {
    @Published var state: AppState
    @Published var path = NavigationPath()
    @Published var colorScheme: ColorScheme = .light
    
    // DeepLink
    @Published var showDeepLinkAlert: Bool = false
    @Published var showJoinFailAlert: Bool = false
    @Published var showJoinSuccessAlert: Bool = false
    @Published var deepLinkAlertData: DeepLinkAlertData?
    
    func setDeepLinkAlertData(_ data: DeepLinkAlertData) {
        self.deepLinkAlertData = data
    }
    
    func setDarkMode() {
        self.colorScheme = .dark
    }
    
    func setLightMode() {
        self.colorScheme = .light
    }
    
    func popToRoot() {
        setLightMode()
        path = .init()
    }
    
    func switchRoot(_ state: AppState) {
        if state == .home { setLightMode() }
        withAnimation { self.state = state }
        print("Switch Root to \(state.rawValue)")
    }
    
    func push(_ at: MainHomeViewDestination) {
        self.path.append(at)
    }
    
    init() {
        let isLoggedIn = UserDefaultsManager.shared.checkLoginStatus()
        let isExistingUser = UserDefaultsManager.shared.isExistingUser()
        
        if isLoggedIn {
            self.state = isExistingUser ? .home : .startGuide
        } else {
            self.state = .onboarding
        }
    }
}

struct RootView: View {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        Group {
            switch appStateManager.state {
            case .splash:
                NavigationStack {
//                    SplashView()
                }
                
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
}
