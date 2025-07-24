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
    
    // MARK: - UseCase
    @Injected(\.getFullStudyInfoUseCase) private var getFullStudyInfoUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let dataSource = StudyDataSource()
    
    init(fullStudyInfo: FullStudyInfoVO) {
        self.fullStudyInfo = fullStudyInfo
    }
    
}

