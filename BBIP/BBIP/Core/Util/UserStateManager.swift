//
//  UserStateManager.swift
//  BBIP
//
//  Created by 이건우 on 10/2/24.
//

import Foundation

final class UserStateManager {
    private let userDataSource = UserDataSource()
    
    /// 기존 유저인지 확인 후, 아니라면 userDefault를 업데이트 합니다.
    func updateIsExistingUser(completion: @escaping () -> Void) {
        if UserDefaultsManager.shared.isExistingUser() {
            
            BBIPLogger.log("기존 유저입니다.", level: .info, category: .feature(featureName: "[UserStateManager]]"))
            completion()
            return
        }
        
        userDataSource.checkIsNewUser { result in
            BBIPLogger.log("checking is new user...", level: .info, category: .feature(featureName: "[UserStateManager]]"))
            UserDefaultsManager.shared.setIsExistingUser(!result)
            
            let resultMessage: String = result ? "신규유저 입니다." : "지금부터 기존유저로 세팅됩니다."
            BBIPLogger.log(resultMessage, level: .info, category: .feature(featureName: "[UserStateManager]]"))
            
            completion()
        }
    }
}
