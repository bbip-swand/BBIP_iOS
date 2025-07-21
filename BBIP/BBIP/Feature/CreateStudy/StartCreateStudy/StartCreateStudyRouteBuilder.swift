//
//  StartCreateStudyRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator

struct StartCreateStudyRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.startCreateStudy.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, _ in
            return WrappingController(matchPath: matchPath) {
                StartCreateStudyView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
