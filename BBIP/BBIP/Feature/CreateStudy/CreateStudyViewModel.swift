//
//  CreateStudyViewModel.swift
//  BBIP
//
//  Created by 이건우 on 8/29/24.
//

import Foundation
import Combine
import UIKit

class CreateStudyViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var contentData: [CreateStudyContent]
    @Published var canGoNext: [Bool] = [
        false,  // 카테고리 분야 선택
        false,  // 기간 및 주차 횟수 선택
        false,  // 스터디 프로필
        false,  // 스터디 한 줄 소개
        true    // 주차별 계획
    ]
    
    // MARK: - Category Setting View
    // 스터디 분야
    @Published var selectedCategoryIndex: [Int] = .init()
    
    // MARK: - Period Setting View
    // 총 주차
    @Published var weekCount: Int = 12 {
        didSet {
            initalWeeklyContentData()
            calculateDeadline()
        }
    }
    @Published var periodIsSelected: Bool = false
    @Published var startDate: Date = Date()
    @Published var deadlineDate: Date? = nil
    
    @Published var selectedDayIndex: [Int] = .init()
    @Published var selectedDayStudySession: [StudySessionVO] = .init()
    @Published var showInvalidTimeAlert: Bool = false
    
    // 스터디 생성 타입
    var setupType: StudyInfoSetupType
    var originalStudyInfo: ModifyStudyInfoVO?    // 수정 확인 용
    var imageUrl: String?
    
    func createEmptyDay() {
        selectedDayIndex.append(-1)
        selectedDayStudySession.append(.emptySession())
    }
    func deleteDay(at index: Int) {
        selectedDayIndex.remove(at: index)
        selectedDayStudySession.remove(at: index)
    }
    
    // MARK: - Profile Setting View
    @Published var studyName: String = .init()
    @Published var isNameValid: Bool = false
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool = false
    @Published var hasStartedEditing: Bool = false
    
    // MARK: - Description Input View
    @Published var studyDescription: String = .init()
    
    // MARK: - Weekly Content Input View
    @Published var weeklyContentData: [String?] = Array(repeating: "", count: 12) // initial value
    @Published var goEditPeriod: Bool = false
    
    // MARK: - Handle Complete
    @Published var showCompleteView: Bool = false
    var createdStudyId: String = .init()
    var studyInviteCode: String = .init()
    
    // MARK: - UseCase
    private let createStudyInfoUseCase: CreateStudyUseCaseProtocol
    private let editStudyInfoUseCase: EditStudyUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(createStudyInfoUseCase: CreateStudyUseCaseProtocol, editStudyInfoUseCase: EditStudyUseCaseProtocol, type: StudyInfoSetupType) {
        self.createStudyInfoUseCase = createStudyInfoUseCase
        self.editStudyInfoUseCase = editStudyInfoUseCase
        self.contentData = CreateStudyContent.generate()
        self.setupType = type
        
        switch type {
        case .create: return
        case .edit(let studyInfo):
            self.originalStudyInfo = ModifyStudyInfoVO(studyInfo) // 원본 데이터 저장
            self.editLoadStudyInfo(studyInfo) // 뷰 모델의 프로퍼티에 기존 데이터 대입
        }
        sinkElements()
    }
    
    private func sinkElements() {
        // SISPeriodView 다음 버튼 상태
        Publishers.CombineLatest4($weekCount, $periodIsSelected, $selectedDayIndex, $selectedDayStudySession)
            .sink { [weak self] (weekCount, periodIsSelected, selectedDayIndex, selectedDayStudySessions) in
                guard let self = self else { return }
                
                // 같은 요일 방지
                let noDuplicatesInDayIndex = Set(selectedDayIndex).count == selectedDayIndex.count
                
                // selectedDayIndex에 -1이 없고, selectedDayStudySession에 nil 값이 없는지 확인
                let allDaysValid = !selectedDayIndex.contains(-1) && selectedDayIndex.count > 0
                let allSessionsValid = !selectedDayStudySessions.contains { $0.startTime == nil || $0.endTime == nil }
                
                // 시작 시간이 종료 시간보다 늦은 상태 감지
                let startTimeBeforeEndTime = !selectedDayStudySessions.contains {
                    guard let startTime = $0.startTime, let endTime = $0.endTime else { return false }
                    return startTime >= endTime
                }
                // 시작 시간이 종료 시간보다 늦은 경우 alert 표시
                self.showInvalidTimeAlert = !startTimeBeforeEndTime
                
                // canGoNext[1]을 true로 설정할 조건
                self.canGoNext[1] = (weekCount > 0 && periodIsSelected)
                                                && allDaysValid
                                                && allSessionsValid
                                                && startTimeBeforeEndTime
                                                && noDuplicatesInDayIndex
            }
            .store(in: &cancellables)
    }
    
    func createStudy() {
        isLoading = true
        let uploadPublisher: AnyPublisher<String, Error>
        
        // 사용자가 이미지를 선택했다면 업로드 후 S3 bucket url, 아니라면 빈 문자열로 VO 생성
        if let selectedImage = selectedImage {
            uploadPublisher = AWSS3Manager.shared.upload(image: selectedImage)
        } else {
            uploadPublisher = Just("")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        uploadPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] uploadedImageUrl -> AnyPublisher<CreateStudyResponseDTO, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
                }
                
                let vo = CreateStudyInfoVO(
                    category: selectedCategoryIndex[0],
                    weekCount: weekCount,
                    startDate: startDate,
                    endDate: deadlineDate!,
                    dayIndexArr: selectedDayIndex,
                    studySessionArr: selectedDayStudySession,
                    name: studyName,
                    imageURL: uploadedImageUrl,
                    description: studyDescription,
                    weeklyContent: weeklyContentData
                )
                
                return self.createStudyInfoUseCase.execute(studyInfoVO: vo)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    print("스터디 생성 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.showCompleteView = true
                print("\(createdStudyId) 스터디 생성 성공")
            }
            .store(in: &cancellables)
    }

    // 시작일로부터 주차 계산해 마감일 계산
    func calculateDeadline() {
        if let addedWeeks = Calendar.current.date(
            byAdding: .weekOfYear,
            value: weekCount,
            to: startDate
        ) {
            // 1일을 뺌 (7N - 1)
            deadlineDate = Calendar.current.date(byAdding: .day, value: -1, to: addedWeeks)
            periodIsSelected = true
        }
    }
    
    func initalWeeklyContentData() {
        let currentCount = weeklyContentData.count
        var newData = Array(repeating: "", count: weekCount)
        
        // 기존 데이터 중에서 유지할 데이터가 있는 경우 복사
        for index in 0..<min(currentCount, weekCount) {
            newData[index] = weeklyContentData[index] ?? ""
        }
        weeklyContentData = newData
        print(weeklyContentData.count, weeklyContentData)
    }
    
    func editStudy() {
        isLoading = true
        
        // 수정 모드에서는 originalStudyInfo에서 studyId를 가져와 사용합니다.
        guard let originalStudyId = originalStudyInfo?.studyId else {
            print("Error: Original study ID not found for editing.")
            isLoading = false
            return
        }
        
        let uploadPublisher: AnyPublisher<String, Error>
        
        if let selectedImage = selectedImage {
            // 이미지가 변경되었거나 새로 추가된 경우
            uploadPublisher = AWSS3Manager.shared.upload(image: selectedImage)
        } else if let originalImageUrl = originalStudyInfo?.studyImageUrl, !originalImageUrl.isEmpty {
            // 이미지가 없지만, 기존 이미지 URL이 있다면 해당 URL을 그대로 사용
            uploadPublisher = Just(originalImageUrl)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        else {
            // 이미지가 없고, 기존 이미지 URL도 없다면 빈 문자열 사용
            uploadPublisher = Just("")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // 해당 정보 ModifyStudyInfoVO에 맞게 변환
        let formatter = DateFormatter.yyyyMMdd
        let formatterHHMM = DateFormatter.hhMM
        
        
        let studyTimes = selectedDayStudySession.map { session in
            return StudyTime(
                startTime: formatterHHMM.string(from: session.startTime!),
                endTime: formatterHHMM.string(from: session.endTime!)
            )
        }
        
        uploadPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] uploadedImageUrl -> AnyPublisher<Bool, Error> in // 수정 UseCase의 반환 타입에 맞게 변경
                guard let self = self else {
                    return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
                }
                
                let studyField = StudyField(intValue: selectedCategoryIndex[0]) ?? .ETC
                
                let vo = ModifyStudyInfoVO(
                    studyId: originalStudyId,
                    studyName: studyName,
                    studyImageUrl: uploadedImageUrl,
                    field: studyField,
                    totalWeeks: weekCount,
                    studyStartDate: formatter.string(from: startDate),
                    studyEndDate: formatter.string(from: deadlineDate!),
                    daysOfWeeks: selectedDayIndex,
                    studyTimes: studyTimes,
                    studyDescription: studyDescription,
                    studyContents: weeklyContentData.map { $0 ?? "" }
                )
                
                return self.editStudyInfoUseCase.execute(studyID: originalStudyId, modifyStudyInfoVO: vo)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.isLoading = false
                        print("스터디 수정 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.showCompleteView = true
                print("\(originalStudyId) 스터디 수정 성공")
            }
            .store(in: &cancellables)
    }
    
    /// Edit 초기 데이터 세팅
    private func editLoadStudyInfo(_ studyInfo: FullStudyInfoVO) {
        let formatter = DateFormatter.edityyyyMMdd
        let formatter2 = DateFormatter.edithhMMSS
        
        guard let startDate = formatter.date(from: studyInfo.studyStartDate),
              let endDate = formatter.date(from: studyInfo.studyEndDate) else {
            return
        }
        
        self.selectedCategoryIndex = [studyInfo.studyField.intValue]
        self.weekCount = studyInfo.totalWeeks
        self.startDate = startDate
        self.deadlineDate = endDate
        self.periodIsSelected = true // 날짜가 있다면 기간이 선택된 것으로 간주
        self.selectedDayIndex = studyInfo.daysOfWeek
        self.selectedDayStudySession = studyInfo.studyTimes.map {
            print("🛠️🛠️🛠️🛠️🛠️🛠️🛠️🛠️🛠️시간 수정 🛠️🛠️🛠️🛠️🛠️🛠️🛠️🛠️🛠️")
            print("원본 startTime: \($0.startTime)")
            print("원본 endTime: \($0.endTime)")
            print("startTime: \(formatter2.date(from: $0.startTime))")
            print("endTime: \(formatter2.date(from: $0.endTime))")
            
            return StudySessionVO(startTime: formatter2.date(from: $0.startTime), endTime: formatter2.date(from: $0.endTime))
        }
        self.studyName = studyInfo.studyName
        self.studyDescription = studyInfo.studyDescription
        self.weeklyContentData = studyInfo.studyContents
        self.imageUrl = studyInfo.studyImageURL
        
        self.canGoNext = [
            true,  // 카테고리 분야 선택
            true,  // 기간 및 주차 횟수 선택
            true,  // 스터디 프로필
            true,  // 스터디 한 줄 소개
            true    // 주차별 계획
        ]
    }
}
