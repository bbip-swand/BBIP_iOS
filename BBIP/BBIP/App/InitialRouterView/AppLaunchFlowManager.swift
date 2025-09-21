//
//  AppLaunchFlowManager.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import UIKit
import Combine
import Foundation
import LinkNavigator

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
                
                // 버전에 따른 업데이트 Alert 표시
                Task { [weak self] in
                    guard let self else { return }
                    if let updateAlertType = await self.getUpdateAlertType() {
                        let alertModel = self.makeAlertModel(alertType: updateAlertType)
                        await MainActor.run {
                            self.navigator.alert(target: .default, model: alertModel)
                        }
                    }
                }
            }
        }
    }
    
    private func makeAlertModel(alertType: UpdateAlertType) -> Alert {
        switch alertType {
        case .forceUpdate:
            return Alert(
                title: alertType.title,
                message: alertType.message,
                buttons: [
                    .init(title: "업데이트", style: .default) { self.openAppStoreAndExit() }
                ],
                flagType: .default
            )
        case .featureUpdate:
            return Alert(
                title: alertType.title,
                message: alertType.message,
                buttons: [
                    .init(title: "다음에", style: .cancel),
                    .init(title: "업데이트", style: .default) { self.openAppStoreAndExit() }
                ],
                flagType: .default
            )
        case .minorUpdate:
            return Alert(
                title: alertType.title,
                message: alertType.message,
                buttons: [
                    .init(title: "다음에", style: .cancel),
                    .init(title: "업데이트", style: .default) { self.openAppStoreAndExit() }
                ],
                flagType: .default
            )
        }
    }
    
    private func getUpdateAlertType() async -> UpdateAlertType? {
        
        // bunlde app version과 appstore version 비교
        let bundleVersion = checkBundleVersion()
        let appStoreVersion = await checkAppStoreVersion()
        
        guard !bundleVersion.isEmpty, !appStoreVersion.isEmpty else {
            return nil
        }
        
        // 정수 부분 split 처리 후 배열로 변환
        func normalizedIntParts(_ version: String) -> [Int] {
            let parts = version.split(separator: ".").map(String.init)
            var ints: [Int] = parts.prefix(3).map { Int($0) ?? 0 }
            while ints.count < 3 { ints.append(0) }
            return ints
        }
        
        let bundleParts = normalizedIntParts(bundleVersion)
        let storeParts = normalizedIntParts(appStoreVersion)
        
        // 비교 로직
        if bundleParts[0] < storeParts[0] {
            return .forceUpdate
        } else if bundleParts[0] == storeParts[0] && bundleParts[1] < storeParts[1] {
            return .featureUpdate
        } else if bundleParts[0] == storeParts[0] && bundleParts[1] == storeParts[1] && bundleParts[2] < storeParts[2] {
            return .minorUpdate
        } else {
            return nil
        }
    }
    
    private func checkAppStoreVersion() async -> String {
        let appId = AppUpdateConfig.appstoreAppId
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)&country=kr") else { return "" }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results[0]["version"] as? String { return appStoreVersion }
        } catch {
            BBIPLogger.log("cannot fetch appstore version", level: .debug, category: .default)
        }
        
        return ""
    }
    
    private func checkBundleVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return version
    }
    
    private func openAppStoreAndExit() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(AppUpdateConfig.appstoreAppId)") else { return }
        UIApplication.shared.open(url, options: [:]) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                exit(0)
            }
        }
    }
}
