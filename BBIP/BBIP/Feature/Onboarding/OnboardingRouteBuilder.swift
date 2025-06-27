//
//  OnboardingRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import LinkNavigator
import SwiftUI

struct OnboardingRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.onboarding.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                OnboardingView()
            }
            .defaultContext()
        }
    }
}
