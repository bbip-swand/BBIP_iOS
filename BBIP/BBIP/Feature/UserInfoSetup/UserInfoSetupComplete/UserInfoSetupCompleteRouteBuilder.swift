//
//  UserInfoSetupCompleteRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator

struct UserInfoSetupCompleteRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.userInfoSetupComplete.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            guard let dependency = dependency as? AppDependency else { return nil }
            return WrappingController(matchPath: matchPath) {
                UserInfoSetupCompleteView(navigator: navigator, userName: items["userName"].unwrapped())
                    .environmentObject(dependency.appState)
            }
            .defaultContext()
        }
    }
}
