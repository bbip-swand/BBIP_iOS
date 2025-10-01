//
//  GetIsTodayStudyUseCase.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Combine

protocol GetIsTodayStudyUseCaseProtocol {
    func execute(studyId: String) -> AnyPublisher<Bool, Error>
}

final class GetIsTodayStudyUseCase: GetIsTodayStudyUseCaseProtocol {
    private let repository: StudyRepository
    
    init(repository: StudyRepository) {
        self.repository = repository
    }
    
    func execute(studyId: String) -> AnyPublisher<Bool, Error> {
        repository.getIsTodayStudy(studyId: studyId)
            .eraseToAnyPublisher()
    }
}
