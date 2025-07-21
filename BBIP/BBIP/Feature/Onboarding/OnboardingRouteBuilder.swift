//
//  OnboardingRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import LinkNavigator

struct OnboardingRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.onboarding.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, _ in
            return WrappingController(matchPath: matchPath) {
                OnboardingView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
