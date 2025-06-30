//
//  BBIPMatchPath.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import Foundation

enum BBIPMatchPath: String {
    
    case initialRoute               // 앱 진입 분기점
    
    // MARK: Onboarding
    case splash                     // 스플래시 화면
    case onboarding                 // 온보딩 화면
    case login                      // Apple 로그인 화면
    
    // MARK: Setup & Guide
    case userInfoSetup              // 유저 필수 정보 세팅 화면
    case userInfoSetupComplete      // 유저 필수 정보 세팅 완료 화면
    case startGuide                 // 스터디 생성 또는 가입 유도 화면 (신규 유저 + 가입된 스터디 X)
    
    // MARK: MainHome
    case home
    case notice
    
    // MARK: BNB
    case startCreateStudy           // 스터디 생성 시작 화면
    case studyInfoSetup             // 스터디 기본 정보 세팅 화면
    case studyInfoSetupComplete     // 스터디 생성 완료 화면
    
    // MARK: StudyHome
    case setLocation
    case createCode
    case enterCode
    case showPostingList
    
    // MARK: My Page
    case myPage
}

extension BBIPMatchPath {
    var capitalizedPath: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
