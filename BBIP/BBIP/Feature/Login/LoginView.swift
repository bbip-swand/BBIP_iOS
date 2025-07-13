//
//  LoginView.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI
import AuthenticationServices
import Factory
import LinkNavigator

struct LoginView: View {
    let navigator: LinkNavigatorType
    @EnvironmentObject private var appState: AppStateManager
    @StateObject var viewModel: LoginViewModel = Container.shared.loginViewModel()
    private let userStateManager = UserStateManager()
    
    @State private var firstAnimation: Bool = false
    @State private var secondAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Group {
                Text("새로운 형태의 스터디 보조 서비스")
                    .foregroundStyle(.gray5)
                    .font(.bbip(.body1_m16))
                    .padding(.bottom, 10)
                
                Text("그룹 스터디의 시작,")
                    .font(.bbip(family: .Regular, size: 28))
                
                Text("BBIP과 함께해요")
                    .font(.bbip(.title1_sb28))
                    .padding(.bottom, 60)
                
                Image("bbip-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
            }
            .opacity(firstAnimation ? 1 : 0)
            .animation(.easeIn(duration: 1.5), value: firstAnimation)
            
            Spacer()
            
            AppleSigninButton(viewModel: viewModel)
                .padding(.bottom, 38)       
                .opacity(secondAnimation ? 1 : 0)
                .animation(.easeIn(duration: 1.2), value: secondAnimation)
        }
        .onChange(of: viewModel.UISDataIsEmpty) { _, newValue in
            if newValue {
                navigator.replace(paths: [BBIPMatchPath.userInfoSetup.capitalizedPath], items: [:], isAnimated: false)
                appState.switchRoot(.infoSetup)
            }
        }
        .onChange(of: viewModel.loginSuccess) { _, newValue in
            if newValue {
                userStateManager.updateIsExistingUser {
                    let isExistingUser = UserDefaultsManager.shared.isExistingUser()
                    navigator.replace(paths: [BBIPMatchPath.home.capitalizedPath], items: [:], isAnimated: false)
                    appState.switchRoot(isExistingUser ? .home : .startGuide)
                }
            }
        }
        .onAppear {
            firstAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                secondAnimation = true
            }
        }
        .navigationBarBackButtonHidden()
        .loadingOverlay(isLoading: $viewModel.isLoading, withBackground: false)
    }
}

private struct AppleSigninButton : View {
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Image("apple_login")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 20)
            .overlay {
                 SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = []
                    },
                    onCompletion: { result in
                        viewModel.handleAppleLogin(result: result)
                    }
                )
                .opacity(0.1)
                .blendMode(.overlay)
            }
    }
}

//#Preview {
//    LoginView()
//}
