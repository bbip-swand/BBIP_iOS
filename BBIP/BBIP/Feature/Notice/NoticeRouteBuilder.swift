//
//  NoticeRouteBuilder.swift
//  BBIP
//
//  Created by 최주원 on 6/26/25.
//

import LinkNavigator

struct NoticeRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.notice.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            
            return WrappingController(matchPath: matchPath) {
                NoticeView(navigator: navigator)
            }
            .defaultContext()
        }
    }
}
