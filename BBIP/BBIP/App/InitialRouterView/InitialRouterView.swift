//
//  InitialRouterView.swift
//  BBIP
//
//  Created by 이건우 on 7/30/24.
//

import SwiftUI
import LinkNavigator

struct InitialRouterView: View {
    
    private let appLaunchFlowManager: AppLaunchFlowManager
    
    init(appLaunchFlowManager: AppLaunchFlowManager) {
        self.appLaunchFlowManager = appLaunchFlowManager
    }
    
    var body: some View {
        EmptyView()
            .task {
                appLaunchFlowManager.start()
            }
    }
}
