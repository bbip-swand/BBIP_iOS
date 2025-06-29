//
//  StudyInfoSetupRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator

struct StudyInfoSetupRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.studyInfoSetup.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, _ in
            return WrappingController(matchPath: matchPath) {
                StudyInfoSetupView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
