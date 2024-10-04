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
    @Published var selectedCategoryIndex: [Int] = .init()
    
    // MARK: - Period Setting View
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
    
    private let createStudyInfoUseCase: CreateStudyUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(createStudyInfoUseCase: CreateStudyUseCaseProtocol) {
        self.createStudyInfoUseCase = createStudyInfoUseCase
        self.contentData = CreateStudyContent.generate()
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
                
                return self.createStudyInfoUseCase.excute(studyInfoVO: vo)
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
                self.createdStudyId = response.studyId
                self.studyInviteCode = response.studyInviteCode
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
}
