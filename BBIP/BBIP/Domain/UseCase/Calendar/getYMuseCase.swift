//
//  getScheduleYMuseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation
import Combine

protocol GetYMUseCaseProtocol{
    func execute(year:String, month:String) -> AnyPublisher<[CalendarHomeVO], Error>
}

final class GetYMUseCase: GetYMUseCaseProtocol{
    private let repository: CalendarRepository
    
    init(repository: CalendarRepository){
        self.repository = repository
    }
    
    func execute(year:String, month:String) -> AnyPublisher<[CalendarHomeVO],Error>{
        return repository.getScheduleYM(year: year, month: month)
            .eraseToAnyPublisher()
    }
}

protocol GetMyStudyUseCaseProtocol{
    func execute() -> AnyPublisher<[selectStudyVO], Error>
}

final class GetMystudyUseCase: GetMyStudyUseCaseProtocol{
    private let repository : CalendarRepository
    
    init(repository:CalendarRepository){
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[selectStudyVO], Error>{
        return repository.getMyStudy()
            .eraseToAnyPublisher()
    }
}
