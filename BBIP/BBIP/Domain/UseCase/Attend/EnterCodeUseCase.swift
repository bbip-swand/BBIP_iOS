//
//  File.swift
//  BBIP
//
//  Created by 조예린 on 9/25/24.
//

import Foundation
import Combine

protocol EnterCodeUseCaseProtocol{
    func execute(attendVO: AttendVO) -> AnyPublisher<Void,Error>
}

final class EnterCodeUseCase: EnterCodeUseCaseProtocol{
    private let repository: AttendRepository
    
    init(repository: AttendRepository){
        self.repository = repository
    }
    
    func execute(attendVO: AttendVO) -> AnyPublisher<Void, any Error> {
        repository.enterCode(vo: attendVO)
            .eraseToAnyPublisher()
    }
}
