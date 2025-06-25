//
//  BBIPMatchPath.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import Foundation

enum BBIPMatchPath: String {
    case initialRoute
    
    case splash
    case onboarding
    case infoSetup
    case startGuide
    case home
    
    case notice
    case myPage
    case startCreateStudy
    case setStudyLocation
    case createCodeOnboarding
    case attendanceCertification
    case postingList

    var capitalizedPath: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
