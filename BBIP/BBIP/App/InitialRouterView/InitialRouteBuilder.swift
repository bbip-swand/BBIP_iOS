//
//  RootRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import LinkNavigator

struct InitialRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.initialRoute.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                let appLaunchFlowManager = AppLaunchFlowManager(navigator: navigator)
                InitialRouterView(appLaunchFlowManager: appLaunchFlowManager)
            }
            .defaultContext()
        }
    }
}
