//
//  GetStatusUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/25/24.
//

import Foundation
import Combine

protocol GetStatusUseCaseProtocol{
    func execute() -> AnyPublisher<GetStatusVO, Error>
}

final class GetStatusUseCase: GetStatusUseCaseProtocol{
    private let repository: AttendRepository
    
    init(repository: AttendRepository){
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<GetStatusVO, Error>{
        return repository.getAttendCode()
            .eraseToAnyPublisher()
    }
        
}
