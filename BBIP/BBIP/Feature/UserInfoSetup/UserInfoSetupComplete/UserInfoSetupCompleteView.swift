//
//  UserInfoSetupCompleteView.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI
import LinkNavigator

struct UserInfoSetupCompleteView: View {
    let navigator: LinkNavigatorType
    
    private let userStateManager = UserStateManager()
    private let userName: String
    
    init(
        navigator: LinkNavigatorType,
        userName: String
    ) {
        self.navigator = navigator
        self.userName = userName
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            BBIPLottieView(assetName: "Complete_SignIn", contentMode: .scaleAspectFit, loopMode: .autoReverse)
                .frame(maxWidth: UIScreen.main.bounds.width - 132)
                .frame(height: 260)
            
            Text("회원가입 완료!")
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray6)
                .padding(.top, 47)
                .padding(.bottom, 14)
            
            Group {
                Text("\(userName)님,")
                    .padding(.bottom, 4)
                Text("환영합니다!")
                    .padding(.bottom, 113)
            }
            .font(.bbip(.title1_sb28))
            
            MainButton(text: "시작하기") {
                let isExistingUser = UserDefaultsManager.shared.isExistingUser()
                let destination: BBIPMatchPath = isExistingUser ? .home : .startGuide
                navigator.replace(paths: [destination.capitalizedPath], items: [:], isAnimated: true)
            }
            .padding(.bottom, 39)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            HapticManager.shared.boong()
        }
    }
}
