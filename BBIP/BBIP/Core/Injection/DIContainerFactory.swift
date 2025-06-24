//
//  DIContainerFactory.swift
//  BBIP
//
//  Created by 이건우 on 6/15/25.
//

import Factory

extension Container {
    
    // MARK: - Auth
    var authDataSource: Factory<AuthDataSource> {
        Factory(self) { AuthDataSource() }
    }
    var loginResponseMapper: Factory<LoginResponseMapper> {
        Factory(self) { LoginResponseMapper() }
    }
    var authRepository: Factory<AuthRepository> {
        Factory(self) {
            AuthRepositoryImpl(
                dataSource: self.authDataSource(),
                mapper: self.loginResponseMapper()
            )
        }
    }
    var requestLoginUseCase: Factory<RequestLoginUseCaseProtocol> {
        Factory(self) {
            RequestLoginUseCase(repository: self.authRepository())
        }
    }

    // MARK: - User
    var userDataSource: Factory<UserDataSource> {
        Factory(self) { UserDataSource() }
    }
    var userInfoMapper: Factory<UserInfoMapper> {
        Factory(self) { UserInfoMapper() }
    }
    var userRepository: Factory<UserRepository> {
        Factory(self) {
            UserRepositoryImpl(
                dataSource: self.userDataSource(),
                mapper: self.userInfoMapper()
            )
        }
    }
    var signUpUseCase: Factory<SignUpUseCaseProtocol> {
        Factory(self) {
            SignUpUseCase(repository: self.userRepository())
        }
    }
    var createUserInfoUseCase: Factory<CreateUserInfoUseCaseProtocol> {
        Factory(self) {
            CreateUserInfoUseCase(repository: self.userRepository())
        }
    }
    var getProfileUseCase: Factory<GetProfileUseCaseProtocol> {
        Factory(self) {
            GetProfileUseCase(repository: self.userRepository())
        }
    }
    var resignUserInfoUseCase: Factory<ResignUseCaseProtocol> {
        Factory(self) {
            ResignUseCase(repository: self.userRepository())
        }
    }

    // MARK: - ViewModels
    var loginViewModel: Factory<LoginViewModel> {
        self { LoginViewModel() }
    }

    var userInfoSetupViewModel: Factory<UserInfoSetupViewModel> {
        self { UserInfoSetupViewModel() }
    }
}

