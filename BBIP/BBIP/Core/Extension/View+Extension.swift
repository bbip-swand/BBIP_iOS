//
//  View+Extension.swift
//  BBIP
//
//  Created by 이건우 on 6/29/25.
//

import SwiftUI

// MARK: - NavigationBar
extension View {
    /// Navigation title이 존재하는 뷰에서 전반적으로 사용될 appearance custom 함수
    func setNavigationBarAppearance(
        forDarkView: Bool = false,
        backgroundColor: UIColor? = nil
    ) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground() // Opaque background prevents transparency
//        if let bg = backgroundColor {
//            navigationBarAppearance.backgroundColor = bg
//        } else {
//            navigationBarAppearance.backgroundColor = forDarkView ? .gray9 : .white
//        }
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.titleTextAttributes = [
            .font: UIFont(name: "WantedSans-Medium", size: 20)!,
            .foregroundColor: forDarkView ? UIColor.white : UIColor(hexCode: "1F1F1F")
        ]
        navigationBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}

// MARK: Rounded Corner
struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
