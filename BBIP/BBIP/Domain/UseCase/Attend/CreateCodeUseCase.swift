//
//  AttendUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/25/24.
//

import Foundation
import Combine

protocol CreateCodeUseCaseProtocol{
    func execute(attendVO: AttendVO) -> AnyPublisher<CreateCodeResponseDTO, Error>
}

final class CreateCodeUseCase: CreateCodeUseCaseProtocol{
    private let repository: AttendRepository
    
    init(repository: AttendRepository){
        self.repository = repository
    }
    
    func execute(attendVO: AttendVO) -> AnyPublisher<CreateCodeResponseDTO, any Error> {
        repository.createCode(vo: attendVO)
            .eraseToAnyPublisher()
    }
}
