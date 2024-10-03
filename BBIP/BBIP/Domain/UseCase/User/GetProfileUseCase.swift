//
//  GetProfileUseCase.swift
//  BBIP
//
//  Created by 조예린 on 10/3/24.
//

import Foundation
import Combine

protocol GetProfileUseCaseProtocol{
    func execute() -> AnyPublisher<UserInfoVO, Error>
}

final class GetProfileUseCase: GetProfileUseCaseProtocol{
    private let repository : UserRepository
    
    init(repository: UserRepository){
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<UserInfoVO, any Error> {
        return repository.getProfileInfo()
            .eraseToAnyPublisher()
    }
}
