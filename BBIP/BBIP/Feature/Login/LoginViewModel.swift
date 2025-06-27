//
//  LoginViewModel.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import Foundation
import Combine
import AuthenticationServices
import Factory

final class LoginViewModel: ObservableObject {
    @Published var loginSuccess: Bool = false
    @Published var UISDataIsEmpty: Bool = false
    @Published var isLoading: Bool = false
    
    @Injected(\.requestLoginUseCase) private var requestLoginUseCase
    @Injected(\.signUpUseCase) private var signUpUseCase
    
    private let userStateManager = UserStateManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var identityToken: String?
    private var authorizationCode: String?
    
    /// BBIP 로직과 별개로 identity Token을 받기 위한 애플 로그인 절차
    func handleAppleLogin(result: Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                
                requestLogin(identityToken: identityToken!)
            default:
                break
            }
        case .failure(let error):
            print("Apple Login Failed: \(error.localizedDescription)")
        }
    }
    
    /// BBIP 로그인 요청
    private func requestLogin(identityToken: String) {
        isLoading = true
        
        requestLoginUseCase.execute(identityToken: identityToken)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    // 신규유저 or Error
                    self.handleError(error)
                }
            } receiveValue: { [weak self] vo in
                guard let self = self else { return }
                UserDefaultsManager.shared.saveAccessToken(token: vo.accessToken)
                
                guard vo.isUserInfoGenerated else {
                    print("기존 유저이지만 UIS 입력 안된 유저입니다 (UISView push)")
                    self.UISDataIsEmpty = true
                    self.isLoading = false
                    return
                }
                
                // MARK: Login Success!
                UserDefaultsManager.shared.setIsLoggedIn(true)
                userStateManager.updateIsExistingUser {
                    self.loginSuccess = true
                    self.isLoading = false
                    print("로그인 성공!")
                }
                
            }.store(in: &cancellables)
    }
    
    /// BBIP 회원가입 처리
    private func signInProcess() {
        guard let identityToken = identityToken,
              let authorizationCode = authorizationCode else {
            print("[LoginViewModel] Missing token or authorization code")
            return
        }
        
        let signUpDTO = SignUpRequestDTO(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fcmToken: UserDefaultsManager.shared.getFCMToken()!
        )
        signUpUseCase.execute(signUpDTO: signUpDTO)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    print(error)
                }
            } receiveValue: { [weak self] vo in
                guard let self = self else { return }
                print("지금 회원가입된 유저입니다")
                UserDefaultsManager.shared.saveAccessToken(token: vo.accessToken)
                print("Saved AccessToken is :", UserDefaultsManager.shared.getAccessToken() ?? "nil")
                self.UISDataIsEmpty = true
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: AuthError) {
        switch error {
        case .notRegisted:
            signInProcess()
        case .unknownError:
            print("[LoginViewModel] requestLogin() Unknown Error! :", error.localizedDescription)
            self.isLoading = false
        }
    }
}
