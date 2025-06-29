//
//  StartGuideRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import SwiftUI
import LinkNavigator

struct StartGuideRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.startGuide.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, _, _ in
            return WrappingController(matchPath: matchPath) {
                StartGuideView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
