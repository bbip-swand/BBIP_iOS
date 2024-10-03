//
//  DIContainer.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation

// Dependency Container
class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - Auth
    private let authDataSource = AuthDataSource()
    private let loginResponseMapper = LoginResponseMapper()
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl(
        dataSource: authDataSource,
        mapper: loginResponseMapper
        
    )
    
    private lazy var requestLoginUseCase: RequestLoginUseCaseProtocol = RequestLoginUseCase(
        repository: authRepository
    )
    
    
    // MARK: - User
    private let userDataSource = UserDataSource()
    private let userInfoMapper = UserInfoMapper()
    private let getprofilemapper = GetProfileMapper()
    private lazy var userRepository: UserRepository = UserRepositoryImpl(
        dataSource: userDataSource,
        mapper: userInfoMapper,
        getprofilemapper: getprofilemapper
    )
    
    private lazy var signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(
        repository: userRepository
    )
    private lazy var createUserInfoUseCase: CreateUserInfoUseCaseProtocol = CreateUserInfoUseCase(
        repository: userRepository
    )
    
    private lazy var getProfileUseCase: GetProfileUseCaseProtocol = GetProfileUseCase(repository: userRepository)
    
    //MARK: - Attend
    private let attendDataSource = AttendDataSource()
    private let getStatusMapper = GetStatusMapper()
    private let createCodeMapper = CreateCodeMapper()
    private let getAttendRecordMapper = GetAttendRecordMapper()
    private let enterCodeMapper = EnterCodeMapper()
    
    private lazy var attendRepository: AttendRepository = AttendRepositoryImpl(
        dataSource: attendDataSource,
        createCodeMapper: createCodeMapper,
        enterCodeMapper: enterCodeMapper,
        getStatusMapper: getStatusMapper,
        getRecordMapper: getAttendRecordMapper
    )
    private lazy var createCodeUseCase: CreateCodeUseCaseProtocol = CreateCodeUseCase(repository: attendRepository)
    
    private lazy var enterCodeUseCase: EnterCodeUseCaseProtocol = EnterCodeUseCase(repository: attendRepository)
    
    private lazy var getStatusUseCase: GetStatusUseCaseProtocol = GetStatusUseCase(repository: attendRepository)
    
    private lazy var getAttendRecordUseCase: GetAttendRecordUseCaseProtocol = GetAttendRecordUseCase(repository: attendRepository)
    
    //MARK: -Calendar
    private let calendarDataSource = CalendarDataSource()
    private let getScheduleMapper = GetScheduleMapper()
    private let createScheduleMapper = CreateScheduleMapper()
    private let getMyStudyMapper = GetMyStudyMapper()
    
    private lazy var calendarRepository : CalendarRepository = CalendarRepositoryImpl(
        dataSource: calendarDataSource,
        getScheduleMapper: getScheduleMapper,
        createScheduleMapper: createScheduleMapper,
        getMystudyMapper: getMyStudyMapper
    )
    
    private lazy var getScheduleYMUseCase: GetYMUseCaseProtocol = GetYMUseCase(repository: calendarRepository)
    private lazy var getScheduleDUseCase: GetDateUseCaseProtocol = GetDateUseCase(repository: calendarRepository)
    private lazy var getUpcomingUseCase: GetUpcomingUseCaseProtocol = GetUpcomingUseCase(repository: calendarRepository)
    private lazy var createScheduleUseCase: CreateScheduleUseCaseProtocol = CreateScheduleUseCase(repository: calendarRepository)
    private lazy var updateScheduleUseCase: UpdateScheduleUseCaseProtocol = UpdateScheduleUseCase(repository: calendarRepository)
    private lazy var getMyStudyUseCase: GetMyStudyUseCaseProtocol = GetMystudyUseCase(repository: calendarRepository)
    
    // MARK: - Study
    private let studyDataSource = StudyDataSource()
    
    private let studyInfoMapper = StudyInfoMapper()
    private let createStudyInfoMapper = CreateStudyInfoMapper()
    private let currentWeekStudyInfoMapper = CurrentWeekStudyInfoMapper()
    private let fullStudyInfoMapper = FullStudyInfoMapper()
    
    private lazy var studyRepository: StudyRepository = StudyRepositoryImpl(
        dataSource: studyDataSource,
        studyInfoMapper: studyInfoMapper,
        createStudyInfoMapper: createStudyInfoMapper,
        currentWeekStudyInfoMapper: currentWeekStudyInfoMapper, 
        fullStudyInfoMapper: fullStudyInfoMapper
    )
    
    private lazy var createStudyUseCase: CreateStudyUseCaseProtocol = CreateStudyUseCase(
        repository: studyRepository
    )
    private lazy var getCurrentWeekStudyInfoUseCase: GetCurrentWeekStudyInfoUseCaseProtocol = GetCurrentWeekStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var getOngoingStudyInfoUseCase: GetOngoingStudyInfoUseCaseProtocol = GetOngoingStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var joinStudyUseCase: JoinStudyUseCaseProtocol = JoinStudyUseCase(
        repository: studyRepository
    )
    private lazy var getFullStudyInfoUseCase: GetFullStudyInfoUseCaseProtocol = GetFullStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var getFinishedStudyInfoUseCase : GetFinishedStudyInfoUseCaseProtocol = GetFinishedStudyInfoUseCase(repository: studyRepository)
    
    
    // MARK: - Posting
    private let postingDataSource = PostingDataSource()
    private let recentPostMapper = RecentPostMapper()
    private let postDetailMapper = PostDetailMapper()
    private lazy var postingRepository: PostingRepository = PostingRepositoryImpl(
        dataSource: postingDataSource,
        recentPostMapper: recentPostMapper,
        postDetailMapper: postDetailMapper
    )
    
    private lazy var getCurrentWeekPostUseCase: GetCurrentWeekPostUseCaseProtocol = GetCurrentWeekPostUseCase(
        repository: postingRepository
    )
    private lazy var getStudyPostingUseCase: GetStudyPostingUseCaseProtocol = GetStudyPostingUseCase(
        repository: postingRepository
    )
    private lazy var getPostDetailUseCase: GetPostDetailUseCaseProtocol = GetPostDetailUseCase(
        repository: postingRepository
    )
    private lazy var createCommentUseCase: CreateCommentUseCaseProtocol = CreateCommentUseCase(
        repository: postingRepository
    )
    
    // MARK: - Archive
    private let archiveDataSource = ArchiveDataSource()
    private let archivedFileInfoMapper = ArchivedFileInfoMapper()
    private lazy var archiveRepository: ArchiveRepository = ArchiveRepositoryImpl(
        dataSource: archiveDataSource,
        mapper: archivedFileInfoMapper
    )
    
    private lazy var getArchivedFileInfoUseCase: GetArchivedFileInfoUseCaseProtocol = GetArchivedFileInfoUseCase(
        repository: archiveRepository
    )
    // MARK: - ViewModels
    // Login
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            requestLoginUseCase: requestLoginUseCase,
            signUpUseCase: signUpUseCase
        )
    }
    
    // UserInfoSetup
    func makeUserInfoSetupViewModel() -> UserInfoSetupViewModel {
        return UserInfoSetupViewModel(createUserInfoUseCase: createUserInfoUseCase)
    }
    
    // UserHome
    func makeMainHomeViewModel() -> MainHomeViewModel {
        return MainHomeViewModel(
            getCurrentWeekPostUseCase: getCurrentWeekPostUseCase,
            getCurrentWeekStudyInfoUseCase: getCurrentWeekStudyInfoUseCase,
            getOngoingStudyInfoUseCase: getOngoingStudyInfoUseCase
        )
    }
    
    // CreateStudy
    func makeCreateStudyViewModel() -> CreateStudyViewModel {
        return CreateStudyViewModel(createStudyInfoUseCase: createStudyUseCase)
    }
    
    // JoinStudy
    func makeJoinStudyViewModel() -> JoinStudyViewModel {
        return JoinStudyViewModel(joinStudyUseCase: joinStudyUseCase)
    }
    
    //Attend
    func makeAttendViewModel()-> AttendanceCertificationViewModel{
        return AttendanceCertificationViewModel(getAttendRecordUseCase: getAttendRecordUseCase, getStatusUseCase: getStatusUseCase, enterCodeUseCse: enterCodeUseCase)
    }
    
    //Create Code
    func createAttendCodeViewModel()-> CreateCodeViewModel{
        return CreateCodeViewModel(createCodeUseCase: createCodeUseCase)
    }
    
    //Calender
    func makeCalendarVieModel() -> CalendarViewModel{
        return CalendarViewModel(getScheduleYMUseCase: getScheduleYMUseCase, getScheduleDUseCase: getScheduleDUseCase, getUpcomingUseCase: getUpcomingUseCase, createScheduleUseCase: createScheduleUseCase, updateScheduleUseCase: updateScheduleUseCase, getMyStudyUseCase: getMyStudyUseCase )
        
    }
    
    // StudyHome
    func makeStudyHomeViewModel() -> StudyHomeViewModel {
        return StudyHomeViewModel(
            getFullStudyInfoUseCase: getFullStudyInfoUseCase,
            getStudyPostingUseCase: getStudyPostingUseCase
        )
    }
    
    // Archive
    func makeArchiveViewModel() -> ArchiveViewModel {
        return ArchiveViewModel(
            getArchivedFileInfoUseCase: getArchivedFileInfoUseCase
        )
    }
    
    // Posting Detail
    func makePostingDetailViewModel() -> PostingDetailViewModel {
        return PostingDetailViewModel(
            getPostDetailUseCase: getPostDetailUseCase,
            createCommentUseCase: createCommentUseCase
        )
    }
    
    //get user info
    func makeMypageDetailViewModel() -> MypageViewModel{
        return MypageViewModel(getProfileUseCase: getProfileUseCase, getFinishedStudyUseCase: getFinishedStudyInfoUseCase, getOngoingStudyUseCase: getOngoingStudyInfoUseCase )
    }
}
