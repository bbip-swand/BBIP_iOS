//
//  CreateCodeOnboardingBuilder.swift
//  BBIP
//
//  Created by 최주원 on 6/26/25.
//

import LinkNavigator

struct CreateCodeOnboardingBuilder: RouteBuilder {
    var matchPath: String { BBIPMatchPath.createCode.capitalizedPath }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            guard
                let studyId = items["studyId"],
                let sessionKey = items["session"]
            else { return nil }
            
            guard let session: Int = NavigationDataStore.shared.retrieve(forKey: sessionKey) else { return nil }
            
            return WrappingController(matchPath: matchPath) {
                CreateCodeOnboardingView(
                    navigator: navigator,
                    studyId: studyId,
                    session: session
                )
            }
            .emptyTitle()
        }
    }
}
