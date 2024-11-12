//
//  GetMonthlyScheduleUseCase.swift
//  BBIP
//
//  Created by 이건우 on 11/12/24.
//

import Foundation
import Combine

protocol GetMonthlyScheduleUseCaseProtocol {
    func excute(year: Int, month: Int) -> AnyPublisher<[ScheduleVO], Error>
}

final class  GetMonthlyScheduleUseCase: GetMonthlyScheduleUseCaseProtocol {
    private let repository: CalendarRepository
    
    init(repository: CalendarRepository) {
        self.repository = repository
    }
    
    func excute(year: Int, month: Int) -> AnyPublisher<[ScheduleVO], Error> {
        repository.getMonthlySchedule(year: year, month: month)
            .eraseToAnyPublisher()
    }
}
