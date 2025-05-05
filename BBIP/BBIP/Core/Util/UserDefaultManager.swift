//
//  UserDefaultManager.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import Foundation

enum AppEnvironment: String {
    case dev, prod

    static var current: AppEnvironment {
        guard let raw = Bundle.main.infoDictionary?["CONFIGURATION_NAME"] as? String else {
            return .prod
        }
        return AppEnvironment(rawValue: raw.lowercased()) ?? .prod
    }

    var suffix: String {
        switch self {
        case .dev: return "_DEV"
        case .prod: return ""
        }
    }
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}

    private enum UserDefaultKeys: String {
        case accessToken
        case fcmToken
        
        case isLoggedIn
        case isNewUser
        
        var rawValue: String {
            switch self {
            case .accessToken:  "accessToken" + AppEnvironment.current.suffix
            case .fcmToken:     "fcmToken" + AppEnvironment.current.suffix
            case .isLoggedIn:   "isLoggedIn" + AppEnvironment.current.suffix
            case .isNewUser:    "isNewUser" + AppEnvironment.current.suffix
            }
        }
    }

    // MARK: - Setters
    func saveAccessToken(token: String) {
        defaults.set(token, forKey: UserDefaultKeys.accessToken.rawValue)
    }
    
    func saveFCMToken(token: String) {
        defaults.set(token, forKey: UserDefaultKeys.fcmToken.rawValue)
    }
    
    func setIsLoggedIn(_ value: Bool) {
        defaults.set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func setIsExistingUser(_ value: Bool) {
        defaults.set(value, forKey: UserDefaultKeys.isNewUser.rawValue)
    }

    // MARK: - Getters
    func getAccessToken() -> String? {
        return defaults.string(forKey: UserDefaultKeys.accessToken.rawValue)
    }
    
    func getFCMToken() -> String? {
        return defaults.string(forKey: UserDefaultKeys.fcmToken.rawValue)
    }
    
    func checkLoginStatus() -> Bool {
        return defaults.bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func isExistingUser() -> Bool {
        return defaults.bool(forKey: UserDefaultKeys.isNewUser.rawValue)
    }

    // MARK: - Clear Data
    func clearUserData() {
        defaults.removeObject(forKey: UserDefaultKeys.isLoggedIn.rawValue)
        defaults.removeObject(forKey: UserDefaultKeys.isNewUser.rawValue)
        defaults.removeObject(forKey: UserDefaultKeys.accessToken.rawValue)
    }
}
