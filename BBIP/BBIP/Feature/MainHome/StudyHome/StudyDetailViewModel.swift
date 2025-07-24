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
    
    // 수정 view 닫힐 때 데이터 갱신용
    func requestFullStudyInfo() {
        getFullStudyInfoUseCase.execute(studyId: fullStudyInfo.studyId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.fullStudyInfo = response
            }
            .store(in: &cancellables)
    }
    
}

