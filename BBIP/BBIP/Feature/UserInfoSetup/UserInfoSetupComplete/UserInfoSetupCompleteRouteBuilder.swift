//
//  UserInfoSetupCompleteRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator
import SwiftUI

struct UserInfoSetupCompleteRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.userInfoSetupComplete.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, _ in
            return WrappingController(matchPath: matchPath) {
                UserInfoSetupCompleteView(navigator: navigator, userName: items["userName"].unwrapped())
            }
            .defaultContext()
        }
    }
}
