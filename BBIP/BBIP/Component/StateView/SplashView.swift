//
//  SplashView.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import SwiftUI
import Lottie

struct SplashView: View {
    private let splashAnimationName: String = "Splash"
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    var body: some View {
        LottieView(animation: .named(splashAnimationName))
            .playbackMode(LottiePlaybackMode.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
            .animationDidFinish { _ in
                completion()
            }
            .background(.white)
    }
}
