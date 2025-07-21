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
            
            // NOTE: isNewUser: 참여한 스터디가 없는 첫 가입한 유저
            guard let self else { return }
            
            userDataSource.checkUserInfoExists { isExist in
                let isUserInfoExist = isExist
                let isLoggedIn = UserDefaultsManager.shared.checkLoginStatus()
                
                let destination: BBIPMatchPath
                
                // 로그인 여부 값(Local), 필수 정보 세팅 여부 값(Server)
                switch (isLoggedIn, isUserInfoExist) {
                case (false, false):
                    destination = .onboarding
                    
                case (false, true):
                    BBIPLogger.log("Unexpected AppFlow", level: .fault, category: .default)
                    destination = .onboarding
                    
                case (true, false):
                    destination = .userInfoSetup
                    
                case (true, true):
                    destination = isNewUser ? .startGuide : .home
                }
                
                self.navigator.replace(paths: [destination.capitalizedPath], items: [:], isAnimated: false)
            }
        }
    }
}
