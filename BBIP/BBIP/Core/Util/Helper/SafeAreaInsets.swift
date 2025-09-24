//
//  SafeAreaInsets.swift
//  BBIP
//
//  Created by 이건우 on 10/3/24.
//

import SwiftUI
import UIKit

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        // Use UIWindowScene.windows instead of the deprecated UIApplication.shared.windows
        let insets: UIEdgeInsets? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets

        return (insets ?? .zero).insets
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

