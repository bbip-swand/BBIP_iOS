//
//  LoginRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/29/25.
//

import SwiftUI
import LinkNavigator

struct LoginRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.login.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                LoginView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
