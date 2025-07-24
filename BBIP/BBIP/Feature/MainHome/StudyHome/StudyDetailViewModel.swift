//
//  StudyDetailViewModel.swift
//  BBIP
//
//  Created by 최주원 on 7/24/25.
//

import Foundation
import Combine
import Factory

final class StudyDetailViewModel: ObservableObject {
    @Published var fullStudyInfo: FullStudyInfoVO
    @Published var alertType: StudyDetailAlertType = .deleteConfirmation
    @Published var deleteAlertIsPresented = false
    @Published var showStudyEditView = false
    // 삭제 완료 event 전달 Subject
    let deleteSuccessSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - UseCase
    @Injected(\.getFullStudyInfoUseCase) private var getFullStudyInfoUseCase
    private var cancellables = Set<AnyCancellable>()
    private let dataSource = StudyDataSource()
    
    init(fullStudyInfo: FullStudyInfoVO) {
        self.fullStudyInfo = fullStudyInfo
    }
    
    // 커스텀 alert Action
    func alertButtonAction() {
        switch alertType {
            case .deleteConfirmation:
                alertType = .deleteCompleted
                deleteAlertIsPresented = true
            case .deleteCompleted:
                // 삭제 완료 처리
                dataSource.deleteStudy(studyId: fullStudyInfo.studyId) { result in
                    switch result {
                        case .success:
                            // StudyDetailView 이벤트 전달
                            self.deleteSuccessSubject.send()
                        case .failure(let error):
                            print("스터디 삭제 실패: \(error)")
                    }
                }
                return
        }
    }
}

