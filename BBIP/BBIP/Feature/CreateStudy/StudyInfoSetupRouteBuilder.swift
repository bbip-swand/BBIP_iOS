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
        { navigator, _, dependency in
            guard let dependency = dependency as? AppDependency else { return nil }
            
            return WrappingController(matchPath: matchPath) {
                StudyInfoSetupView(navigator: navigator)
                    .environmentObject(dependency.appState)
            }
            .defaultContext()
        }
    }
}
