//
//  OnboardingViewModel.swift
//  BBIP
//
//  Created by 이건우 on 8/11/24.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init() {
        self.onboardingContents = OnboardingContent.generate()
    }
}
