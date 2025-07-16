//
//  EditStudyUseCase.swift
//  BBIP
//
//  Created by 최주원 on 7/15/25.
//

import Combine

protocol EditStudyUseCaseProtocol {
    func execute(studyID: String, modifyStudyInfoVO: ModifyStudyInfoVO) -> AnyPublisher<Bool, Error>
}

final class EditStudyUseCase: EditStudyUseCaseProtocol {
    private let repository: StudyRepository
    
    init(repository: StudyRepository) {
        self.repository = repository
    }
    
    func execute(studyID: String, modifyStudyInfoVO: ModifyStudyInfoVO) -> AnyPublisher<Bool, Error> {
        repository.editStudy(studyId: studyID, vo: modifyStudyInfoVO)
            .eraseToAnyPublisher()
    }
}
