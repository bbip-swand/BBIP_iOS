//
//  UserStateManager.swift
//  BBIP
//
//  Created by 이건우 on 10/2/24.
//

import Foundation

final class UserStateManager {
    private let userDataSource = UserDataSource()
    
    /// `기존 유저`는 진행중인 스터디가 1개 이상인 유저를 말하며, `신규 유저`는 회원가입 후 참여한 스터디가 없는 유저를 말합니다.
    /// `신규 유저`는 홈 화면으로 바로 진입시키지 않고 스터디 참여 또는 생성을 유도하기 때문에 분기 처리가 필요합니다.
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
            
            let resultMessage: String = result ? "신규 유저 입니다." : "지금부터 기존 유저로 세팅됩니다."
            BBIPLogger.log(resultMessage, level: .info, category: .feature(featureName: "[UserStateManager]]"))
            
            completion()
        }
    }
}
