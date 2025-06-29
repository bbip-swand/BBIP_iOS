//
//  AppLaunchFlowManager.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import LinkNavigator
import SwiftUI
import os

final class AppLaunchFlowManager: ObservableObject {
    private let navigator: LinkNavigatorType
    private let userDataSource = UserDataSource()
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    /// 앱 실행 시 초기 진입 경로를 판단하고 이동합니다.
    func start() {
        userDataSource.checkIsNewUser { [weak self] isNewUser in
            guard let self else { return }
            
            let isUserProfileSet = !isNewUser
            let isLoggedIn = UserDefaultsManager.shared.checkLoginStatus()
            UserDefaultsManager.shared.setIsExistingUser(isUserProfileSet)
            
            let destination: BBIPMatchPath
            
            switch (isLoggedIn, isUserProfileSet) {
            case (false, false):
                destination = .onboarding
                
            case (false, true):
                BBIPLogger.log("Unexpected AppFlow", level: .fault, category: .default)
                destination = .onboarding
                
            case (true, false):
                destination = .userInfoSetup
                
            case (true, true):
                let isExistingUser = UserDefaultsManager.shared.isExistingUser()
                destination = isExistingUser ? .home : .startGuide
            }
            
            navigator.replace(paths: [destination.capitalizedPath], items: [:], isAnimated: false)
            
            logging(isUserProfileSet: isUserProfileSet)
        }
    }
}

extension AppLaunchFlowManager {
    private func logging(isUserProfileSet: Bool) {
        if isUserProfileSet {
            BBIPLogger.log("기존 유저로 앱 진입", level: .info, category: .default)
        } else {
            BBIPLogger.log("신규 유저로 앱 진입", level: .info, category: .default)
        }
    }
}
