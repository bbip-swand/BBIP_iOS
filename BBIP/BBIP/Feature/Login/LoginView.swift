//
//  LoginView.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var appState: AppStateManager
    @ObservedObject var viewModel: LoginViewModel = makeLoginViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("새로운 형태의 스터디 보조 서비스")
                .foregroundStyle(.gray6)
                .font(.bbip(.body1_m16))
                .padding(.bottom, 10)
            
            Text("그룹 스터디의 시작,")
                .font(.bbip(family: .Regular, size: 28))
            
            Text("BBIP과 함께해요")
                .font(.bbip(.title1_sb28))
                .padding(.bottom, 60)
            
            Image("mockImg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 58)
            
            Spacer()
            
            AppleSigninButton(viewModel: viewModel)
                .padding(.bottom, 38)       
        }
        .onChange(of: viewModel.UISDataIsEmpty) { _, newValue in
            if newValue {
                withAnimation { appState.goUIS() }
            }
        }
        .onChange(of: viewModel.loginSuccess) { _, newValue in
            if newValue {
                withAnimation { appState.goHome() }
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
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        viewModel.handleAppleLogin(result: result)
                    }
                )
                .blendMode(.overlay)
            }
    }
}

extension LoginView {
    static func makeRequestLoginUseCase() -> RequestLoginUseCase {
        let dataSource = AuthDataSource()
        let mapper = LoginResponseMapper()
        let repository = AuthRepositoryImpl(dataSource: dataSource, mapper: mapper)
        return RequestLoginUseCase(repository: repository)
    }
    
    static func makeSignUpUseCase() -> SignUpUseCase {
        let dataSource = UserDataSource()
        let mapper = UserInfoMapper()
        let repository = UserRepository(dataSource: dataSource, mapper: mapper)
        
        return SignUpUseCase(repository: repository)
    }
    
    static func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            requestLoginUseCase: makeRequestLoginUseCase(),
            signUpUseCase: makeSignUpUseCase()
        )
    }
}

#Preview {
    LoginView()
}
