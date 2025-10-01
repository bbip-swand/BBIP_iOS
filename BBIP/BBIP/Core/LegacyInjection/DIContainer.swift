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
    private lazy var userRepository: UserRepository = UserRepositoryImpl(
        dataSource: userDataSource,
        mapper: userInfoMapper
    )
    
    private lazy var signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(
        repository: userRepository
    )
    private lazy var createUserInfoUseCase: CreateUserInfoUseCaseProtocol = CreateUserInfoUseCase(
        repository: userRepository
    )
    private lazy var getProfileUseCase: GetProfileUseCaseProtocol = GetProfileUseCase(
        repository: userRepository
    )
    private lazy var resignUseCase: ResignUseCaseProtocol = ResignUseCase(
        repository: userRepository
    )
    
    
    // MARK: - Attendance
    private let attendanceDataSource = AttendanceDataSource()
    private let attendanceStatusMapper = AttendanceStatusMapper()
    private let attendanceRecordMapper = AttendanceRecordMapper()
    private lazy var attendanceRepository: AttendanceRepository = AttendanceRepositoryImpl(
        dataSource: attendanceDataSource,
        statusMapper: attendanceStatusMapper,
        recordMapper: attendanceRecordMapper
    )
    
    private lazy var getAttendanceStatusUseCase: GetAttendanceStatusUseCaseProtocol = GetAttendanceStatusUseCase(
        repository: attendanceRepository
    )
    private lazy var getAttendanceRecordsUseCase: GetAttendanceRecordsUseCaseProtocol = GetAttendanceRecordsUseCase(
        repository: attendanceRepository
    )
    private lazy var createAttendanceCodeUseCase: CreateAttendanceCodeUseCaseProtocol = CreateAttendanceCodeUseCase(
        repository: attendanceRepository
    )
    private lazy var submitAttendanceUseCase: SubmitAttendanceCodeUseCaseProtocol = SubmitAttendanceCodeUseCase(
        repository: attendanceRepository
    )
    
    private lazy var getStudyAttendanceStatusUseCase: GetStudyAttendanceStatusUseCaseProtocol = GetStudyAttendanceStatusUseCase(
        repository: attendanceRepository
    )
    
    
    // MARK: - Study
    private let studyDataSource = StudyDataSource()
    
    private let studyInfoMapper = StudyInfoMapper()
    private let createStudyInfoMapper = CreateStudyInfoMapper()
    private let currentWeekStudyInfoMapper = CurrentWeekStudyInfoMapper()
    private let fullStudyInfoMapper = FullStudyInfoMapper()
    private let pendingStudyMapper = PendingStudyMapper()
    
    private lazy var studyRepository: StudyRepository = StudyRepositoryImpl(
        dataSource: studyDataSource,
        studyInfoMapper: studyInfoMapper, 
        createStudyInfoMapper: createStudyInfoMapper,
        currentWeekStudyInfoMapper: currentWeekStudyInfoMapper, 
        fullStudyInfoMapper: fullStudyInfoMapper,
        pendingStudyMapper: pendingStudyMapper
    )
    
    private lazy var createStudyUseCase: CreateStudyUseCaseProtocol = CreateStudyUseCase(
        repository: studyRepository
    )
    // 스터디 수정, 주차 수정 둘다 이용
    private lazy var editStudyUseCase: EditStudyUseCaseProtocol = EditStudyUseCase(
        repository: studyRepository
    )
    private lazy var getCurrentWeekStudyInfoUseCase: GetCurrentWeekStudyInfoUseCaseProtocol = GetCurrentWeekStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var getOngoingStudyInfoUseCase: GetOngoingStudyInfoUseCaseProtocol = GetOngoingStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var getFinishedStudyInfoUseCase: GetFinishedStudyInfoUseCaseProtocol = GetFinishedStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var joinStudyUseCase: JoinStudyUseCaseProtocol = JoinStudyUseCase(
        repository: studyRepository
    )
    private lazy var getFullStudyInfoUseCase: GetFullStudyInfoUseCaseProtocol = GetFullStudyInfoUseCase(
        repository: studyRepository
    )
    private lazy var getPendingStudyUseCase: GetPendingStudyUseCaseProtocol = GetPendingStudyUseCase(
        repository: studyRepository
    )
    
    
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
    
    private lazy var deletePostUseCase: DeletePostUseCaseProtocol = DeletePostUseCase(
        repository: postingRepository
    )
    private lazy var createCommentUseCase: CreateCommentUseCaseProtocol = CreateCommentUseCase(
        repository: postingRepository
    )
    private lazy var deleteCommentUseCase: DeleteCommentUseCaseProtocol = DeleteCommentUseCase(
        repository: postingRepository
    )
    private lazy var createPostingUseCase: CreatePostingUseCaseProtocol = CreatePostingUseCase(
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
    
    // MARK: - Calendar
    private let calendarDataSource = CalendarDataSource()
    private let scheduleMapper = ScheduleMapper()
    private let upcommingScheduleMapper = UpcommingScheduleMapper()
    private lazy var calendarRepository: CalendarRepository = CalendarRepositoryImpl(
        dataSource: calendarDataSource,
        mapper: scheduleMapper,
        upcommingMapper: upcommingScheduleMapper
    )
    
    private lazy var getMonthlyScheduleUseCase: GetMonthlyScheduleUseCaseProtocol = GetMonthlyScheduleUseCase(
        repository: calendarRepository
    )
    private lazy var getUpcommingScheduleUseCase: GetUpcommingScheduleUseCaseProtocol = GetUpcommingScheduleUseCase(
        repository: calendarRepository
    )
    private lazy var createScheduleUseCase: CreateScheduleUseCaseProtocol = CreateScheduleUseCase(
        repository: calendarRepository
    )
    private lazy var updateScheduleUseCase: UpdateScheduleUseCaseProtocol = UpdateScheduleUseCase(
        repository: calendarRepository
    )
    
    // MARK: - ViewModels
    // Login
    //    func makeLoginViewModel() -> LoginViewModel {
    //        return LoginViewModel(signUpUseCase: signUpUseCase)
    //    }
    
    // UserInfoSetup
    // func makeUserInfoSetupViewModel() -> UserInfoSetupViewModel {
    //     return UserInfoSetupViewModel(createUserInfoUseCase: createUserInfoUseCase)
    // }
    
    // UserHome
    func makeUserHomeViewModel() -> UserHomeViewModel {
        return UserHomeViewModel(
            getCurrentWeekPostUseCase: getCurrentWeekPostUseCase, 
            getCurrentWeekStudyInfoUseCase: getCurrentWeekStudyInfoUseCase, 
            getOngoingStudyInfoUseCase: getOngoingStudyInfoUseCase,
            getPendingStudyUseCase: getPendingStudyUseCase,
            getAttendanceStatusUseCase: getAttendanceStatusUseCase,
            getUpcommingScheduleUseCase: getUpcommingScheduleUseCase
        )
    }
    
    // Attendance Certification
    func makeAttendanceCertificationViewModel() -> AttendanceCertificationViewModel {
        return .init(
            submitAttendanceCodeUseCase: submitAttendanceUseCase
        )
    }
    
    // Create Code
    // func makeCreateCodeViewModel() -> CreateCodeViewModel {
    //     return .init(
    //         getAttendanceStatusUseCase: getAttendanceStatusUseCase,
    //         createAttendanceCodeUseCase: createAttendanceCodeUseCase,
    //         getAttendanceRecordsUseCase: getAttendanceRecordsUseCase
    //     )
    // }
    
    // WeeklyStudyEdit
    func makeWeeklyStudyEditViewModel(fullStudyInfoVO: FullStudyInfoVO) -> WeeklyStudyContentListViewModel {
        return .init(fullStudyInfo: fullStudyInfoVO, editStudyUseCase: editStudyUseCase)
    }
    
    // Attendance Records
    func makeAttendanceRecordsViewModel() -> AttendanceRecordsViewModel {
        return .init(
            getAttendanceRecordsUseCase: getAttendanceRecordsUseCase
        )
    }
    
    // CreateStudy
    func makeCreateStudyViewModel(type: StudyInfoSetupType) -> CreateStudyViewModel {
        return CreateStudyViewModel(createStudyInfoUseCase: createStudyUseCase, editStudyInfoUseCase: editStudyUseCase, type: type)
    }
    
    // JoinStudy
    func makeJoinStudyViewModel() -> JoinStudyViewModel {
        return JoinStudyViewModel(joinStudyUseCase: joinStudyUseCase)
    }
    
    // StudyHome
    func makeStudyHomeViewModel() -> StudyHomeViewModel {
        return StudyHomeViewModel(
            getFullStudyInfoUseCase: getFullStudyInfoUseCase,
            getStudyPostingUseCase: getStudyPostingUseCase,
            getStudyAttendanceStatusUseCase: getStudyAttendanceStatusUseCase
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
            deletePostUseCase: deletePostUseCase,
            createCommentUseCase: createCommentUseCase,
            deleteCommentUseCase: deleteCommentUseCase
        )
    }
    
    // Create Posting
    func createPostingViewModel() -> CreatePostingViewModel {
        return .init(
            createPostingUseCase: createPostingUseCase
        )
    }
    
    // MyPage
    func makeMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(
            getProfileUseCase: getProfileUseCase,
            getFinishedStudyUseCase: getFinishedStudyInfoUseCase,
            getOngoingStudyUseCase: getOngoingStudyInfoUseCase,
            resignUseCase: resignUseCase
        )
    }
    
    // Calendar
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(
            getMonthlyScheduleUseCase: getMonthlyScheduleUseCase
        )
    }
    
    // Add Schedule (need fix), crud
    func makeAddScheduleViewModel() -> AddScheculeViewModel {
        return AddScheculeViewModel(
            createScheduleUseCase: createScheduleUseCase
        )
    }
}
