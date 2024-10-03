//
//  createScheduleUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation
import Combine

protocol CreateScheduleUseCaseProtocol{
    func execute(calendarVO: CreateScheduleVO) -> AnyPublisher<Void,Error>
}

final class CreateScheduleUseCase: CreateScheduleUseCaseProtocol{
    private let repository: CalendarRepository
    
    init(repository: CalendarRepository){
        self.repository = repository
    }
    
    func execute(calendarVO: CreateScheduleVO) -> AnyPublisher<Void, any Error> {
        return repository.createSchedule(vo: calendarVO)
            .eraseToAnyPublisher()
    }
}
