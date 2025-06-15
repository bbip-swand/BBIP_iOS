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

    var capitalizedPath: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
