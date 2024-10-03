//
//  GetPendingStudyUseCase.swift
//  BBIP
//
//  Created by 조예린 on 10/4/24.
//

import Foundation
import Combine

protocol GetPendingStudyUseCaseProtocol {
    func excute() -> AnyPublisher<PendingVO, Error>
}

final class GetPendingStudyUseCase: GetPendingStudyUseCaseProtocol {
    private let repository: StudyRepository
    
    init(repository: StudyRepository) {
        self.repository = repository
    }
    
    func excute() -> AnyPublisher<PendingVO, Error> {
        repository.getPendingStudy()
            .eraseToAnyPublisher()
    }
}
