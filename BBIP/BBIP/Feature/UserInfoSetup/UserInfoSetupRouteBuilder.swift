//
//  UserInfoSetupRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/24/25.
//

import LinkNavigator
import SwiftUI

struct UserInfoSetupRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.userInfoSetup.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, _ in
            return WrappingController(matchPath: matchPath) {
                UserInfoSetupView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
