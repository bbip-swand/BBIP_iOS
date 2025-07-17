//
//  UpdateScheduleUseCase.swift
//  BBIP
//
//  Created by 이건우 on 11/14/24.
//

import Combine

protocol UpdateScheduleUseCaseProtocol {
    func execute(scheduleId: Int, dto: ScheduleFormDTO) -> AnyPublisher<Void, Error>
}

final class UpdateScheduleUseCase: UpdateScheduleUseCaseProtocol {
    private let repository: CalendarRepository
    
    init(repository: CalendarRepository) {
        self.repository = repository
    }
    
    func execute(scheduleId: Int, dto: ScheduleFormDTO) -> AnyPublisher<Void, Error> {
        repository.updateSchedule(scheduleId: scheduleId, dto: dto)
            .eraseToAnyPublisher()
    }
}
