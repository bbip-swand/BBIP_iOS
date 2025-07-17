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
    
    // MARK: Study
    var studyDataSource: Factory<StudyDataSource> {
        Factory(self) { StudyDataSource() }
    }
    var studyInfoMapper: Factory<StudyInfoMapper> {
        Factory(self) { StudyInfoMapper() }
    }
    var createStudyInfoMapper: Factory<CreateStudyInfoMapper> {
        Factory(self) { CreateStudyInfoMapper() }
    }
    var currentWeekStudyInfoMapper: Factory<CurrentWeekStudyInfoMapper> {
        Factory(self) { CurrentWeekStudyInfoMapper() }
    }
    var fullStudyInfoMapper: Factory<FullStudyInfoMapper> {
        Factory(self) { FullStudyInfoMapper() }
    }
    var pendingStudyMapper: Factory<PendingStudyMapper> {
        Factory(self) { PendingStudyMapper() }
    }
    var studyRepository: Factory<StudyRepository> {
        Factory(self) {
            StudyRepositoryImpl(
                dataSource: self.studyDataSource(),
                studyInfoMapper: self.studyInfoMapper(),
                createStudyInfoMapper: self.createStudyInfoMapper(),
                currentWeekStudyInfoMapper: self.currentWeekStudyInfoMapper(),
                fullStudyInfoMapper: self.fullStudyInfoMapper(),
                pendingStudyMapper: self.pendingStudyMapper())
        }
    }
    var createStudyUseCase: Factory<CreateStudyUseCaseProtocol> {
        Factory(self) {
            CreateStudyUseCase(repository: self.studyRepository())
        }
    }
    var getCurrentWeekStudyInfoUseCase: Factory<GetCurrentWeekStudyInfoUseCaseProtocol> {
        Factory(self) {
            GetCurrentWeekStudyInfoUseCase(repository: self.studyRepository())
        }
    }
    var getOngoingStudyInfoUseCase: Factory<GetOngoingStudyInfoUseCaseProtocol> {
        Factory(self) {
            GetOngoingStudyInfoUseCase(repository: self.studyRepository())
        }
    }
    var getFinishedStudyInfoUseCase: Factory<GetFinishedStudyInfoUseCaseProtocol> {
        Factory(self) {
            GetFinishedStudyInfoUseCase(repository: self.studyRepository())
        }
    }
    var joinStudyUseCase: Factory<JoinStudyUseCaseProtocol> {
        Factory(self) {
            JoinStudyUseCase(repository: self.studyRepository())
        }
    }
    var getFullStudyInfoUseCase: Factory<GetFullStudyInfoUseCaseProtocol> {
        Factory(self) {
            GetFullStudyInfoUseCase(repository: self.studyRepository())
        }
    }
    var getPendingStudyUseCase: Factory<GetPendingStudyUseCaseProtocol> {
        Factory(self) {
            GetPendingStudyUseCase(repository: self.studyRepository())
        }
    }

    // MARK: - ViewModels
    var onboardingViewModel: Factory<OnboardingViewModel> {
        self { OnboardingViewModel() }
    }
    
    var loginViewModel: Factory<LoginViewModel> {
        self { LoginViewModel() }
    }

    var userInfoSetupViewModel: Factory<UserInfoSetupViewModel> {
        self { UserInfoSetupViewModel() }
    }
    
//    var createStudyViewModel: Factory<CreateStudyViewModel> {
//        self { CreateStudyViewModel() }
//    }
}

