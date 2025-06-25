//
//  OnboardingBuilder.swift
//  BBIP
//
//  Created by 최주원 on 6/15/25.
//

import LinkNavigator

struct OnboardingBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.onboarding.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                let appLaunchFlowManager = AppLaunchFlowManager(navigator: navigator)
                OnboardingView()
            }
            .emptyTitle()
        }
    }
}
