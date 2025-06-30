//
//  StudyInfoSetupCompleteRouteBuilder.swift
//  BBIP
//
//  Created by 이건우 on 6/30/25.
//

import LinkNavigator

struct StudyInfoSetupCompleteRouteBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.studyInfoSetupComplete.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, _ in
            return WrappingController(matchPath: matchPath) {
                StudyInfoSetupCompleteView(navigator: navigator,
                                           studyId: items["studyId"].unwrapped(),
                                           studyInviteCode: items["studyInviteCode"].unwrapped())
            }
            .defaultContext()
        }
    }
}
