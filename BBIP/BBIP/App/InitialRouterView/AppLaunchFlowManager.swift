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
            
            if isLoggedIn == false {
                self.navigator.replace(paths: [BBIPMatchPath.onboarding.capitalizedPath], items: [:], isAnimated: false)
            } else if isUserProfileSet == false {
                self.navigator.replace(paths: [BBIPMatchPath.userInfoSetup.capitalizedPath], items: [:], isAnimated: false)
            } else {
                self.navigator.replace(paths: [BBIPMatchPath.home.capitalizedPath], items: [:], isAnimated: false)
            }
            
            logging(isUserProfileSet: isUserProfileSet)            
        }
    }
}

extension AppLaunchFlowManager {
    private func logging(isUserProfileSet: Bool) {
        if isUserProfileSet {
            Logger().info("\(#file) 기존 유저")
        } else {
            Logger().info("\(#file) 신규 유저")
        }
    }
}
