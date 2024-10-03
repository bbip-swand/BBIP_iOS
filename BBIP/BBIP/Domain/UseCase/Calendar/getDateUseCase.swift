//
//  getScheduleDateUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation
import Combine

protocol GetDateUseCaseProtocol{
    func execute(date:String) -> AnyPublisher<[CalendarHomeVO], Error>
}

final class GetDateUseCase: GetDateUseCaseProtocol{
    private let repository: CalendarRepository
    
    init (repository: CalendarRepository){
        self.repository = repository
    }
    
    func execute(date: String) -> AnyPublisher<[CalendarHomeVO], any Error> {
        return repository.getScheduleDate(date: date)
            .eraseToAnyPublisher()
    }
}
