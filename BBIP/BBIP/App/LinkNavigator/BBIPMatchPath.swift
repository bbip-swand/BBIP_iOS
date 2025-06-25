//
//  BBIPMatchPath.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import Foundation

enum BBIPMatchPath: String {
    
    case initialRoute       // 앱 진입 분기점
    
    
    case splash             // 스플래시 화면
    case onboarding         // 온보딩 화면
    case login              // Apple 로그인 화면
    
    
    case userInfoSetup      // 유저 필수 정보 세팅
    case startGuide         // 스터디 생성 또는 가입 유도 화면 (신규 유저 + 가입된 스터디 X)
    
    
    case home
}

extension BBIPMatchPath {
    var capitalizedPath: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
