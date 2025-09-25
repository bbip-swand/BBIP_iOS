//
//  CreateAttendanceCodeOnboardingViewModel.swift
//  BBIP
//
//  Created by 이건우 on 9/25/25.
//

import Foundation
import Combine
import Factory

/// 출석 코드 생성 전 요일 및 상태 확인
final class CreateAttendanceCodeOnboardingViewModel: ObservableObject {
    
    @Injected(\.getIsTodayStudyUseCase) private var getIsTodayStudyUseCase
    
    @Published var showIsNotTodayStudyWarningAlert: Bool = false
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkIsTodayStudy(studyId: String) {
        isLoading = true

        getIsTodayStudyUseCase.execute(studyId: studyId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionResult in
                guard let self else { return }
                self.isLoading = false
                
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    BBIPLogger.log(error.localizedDescription, level: .error, category: .network)
                }
            } receiveValue: { [weak self] isTodayStudy in
                guard let self else { return }
                self.showIsNotTodayStudyWarningAlert = !isTodayStudy
            }
            .store(in: &cancellables)
    }
}
