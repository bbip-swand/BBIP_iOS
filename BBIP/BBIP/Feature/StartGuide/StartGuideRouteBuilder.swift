//
//  StartGuideRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator

struct StartGuideRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.startGuide.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, dependency in
            guard let dependency = dependency as? AppDependency else { return nil }
            return WrappingController(matchPath: matchPath) {
                StartGuideView(navigator: navigator)
                    .environmentObject(dependency.appState)
            }
            .defaultContext()
        }
    }
}
