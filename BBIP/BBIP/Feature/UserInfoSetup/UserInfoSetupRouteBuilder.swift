//
//  UserInfoSetupRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/24/25.
//

import LinkNavigator

struct UserInfoSetupRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.userInfoSetup.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, _ in
            return WrappingController(matchPath: matchPath) {
                UserInfoSetupView(navigator: navigator, appleUserName: items["appleUserName"].unwrapped())
            }
            .defaultContext()
        }
    }
}
