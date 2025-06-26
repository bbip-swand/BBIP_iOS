//
//  MainHomeBuilder.swift
//  BBIP
//
//  Created by 최주원 on 6/15/25.
//

import LinkNavigator

struct MainHomeBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.home.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            guard let dependency = dependency as? AppDependency else { return nil }
            
            return WrappingController(matchPath: matchPath) {
                MainHomeView(navigator: navigator)
                    .toolbar(.hidden, for: .navigationBar)
                    .environmentObject(dependency.appState)
            }
            .emptyTitle()
        }
    }
}
