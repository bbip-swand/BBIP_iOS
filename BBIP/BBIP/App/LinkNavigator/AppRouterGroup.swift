//
//  AppRouterGroup.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import LinkNavigator

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
        InitialRouteBuilder(),
        OnboardingRouteBuilder(),
        LoginRouteBuilder(),
        UserInfoSetupRouteBuilder(),
        UserInfoSetupCompleteRouteBuilder(),
        StartGuideRouteBuilder(),
        MainHomeRouteBuilder(),
        NoticeRouteBuilder(),
        MyPageRouteBuilder()
    ]
  }
}
