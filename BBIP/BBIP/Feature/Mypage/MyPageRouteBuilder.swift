//
//  MyPageRouteBuilder.swift
//  BBIP
//
//  Created by 최주원 on 6/26/25.
//

import LinkNavigator

struct MyPageRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.myPage.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            
            return WrappingController(matchPath: matchPath) {
                MypageView(navigator: navigator)
                    .toolbar(.visible, for: .navigationBar)
            }
            .defaultContext()
        }
    }
}

