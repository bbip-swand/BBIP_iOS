//
//  LoginViewRouterBuilder.swift
//  BBIP
//
//  Created by 최주원 on 7/10/25.
//

import Foundation
import LinkNavigator

struct LoginViewRouterBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.login.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            guard let dependency = dependency as? AppDependency else { return nil }
            return WrappingController(matchPath: matchPath) {
                    LoginView(navigator: navigator)
                        .environmentObject(dependency.appState)
            }
            .defaultContext()
        }
    }
}
