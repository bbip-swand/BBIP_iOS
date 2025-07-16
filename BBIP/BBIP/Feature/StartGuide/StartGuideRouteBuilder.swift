//
//  StartGuideRouteBuilder.swift
//  BBIP
//
//  Created by 최주원 on 7/17/25.
//

import LinkNavigator
import UIKit

struct StartGuideRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.startGuide.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                StartGuideView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
