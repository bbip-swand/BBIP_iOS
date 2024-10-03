//
//  getUpcomingUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation
import Combine

protocol GetUpcomingUseCaseProtocol{
    func execute() -> AnyPublisher<[CalendarHomeVO],Error>
}

final class GetUpcomingUseCase: GetUpcomingUseCaseProtocol{
    private let repository: CalendarRepository
    
    init(repository: CalendarRepository){
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[CalendarHomeVO], any Error> {
        return repository.getUpcoming()
            .eraseToAnyPublisher()
        
    }
}
