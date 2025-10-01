//
//  OnboardingContent.swift
//  BBIP
//
//  Created by 이건우 on 8/11/24.
//

import Foundation

struct OnboardingContent: Hashable {
    let textImageName: String
    let imageName: String
}

extension OnboardingContent {
    static func generate() -> [OnboardingContent] {
        return [
            OnboardingContent(textImageName: "onboardingText_1", imageName: "onboarding_1"),
            OnboardingContent(textImageName: "onboardingText_2", imageName: "onboarding_2"),
            OnboardingContent(textImageName: "onboardingText_3", imageName: "onboarding_3"),
            OnboardingContent(textImageName: "onboardingText_4", imageName: "onboarding_4")
        ]
    }
}
