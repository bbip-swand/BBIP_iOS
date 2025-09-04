//
//  CalendarRepository.swift
//  BBIP
//
//  Created by 이건우 on 11/12/24.
//

import Foundation
import Combine

protocol CalendarRepository {
    func getMonthlySchedule(year: Int, month: Int) -> AnyPublisher<[ScheduleVO], Error>
    func getUpcommingSchdule() -> AnyPublisher<[UpcommingScheduleVO], Error>
    func createSchedule(dto: ScheduleFormDTO) -> AnyPublisher<Void, Error>
    func updateSchedule(scheduleId: Int, dto: ScheduleFormDTO) -> AnyPublisher<Void, Error>
}

final class CalendarRepositoryImpl: CalendarRepository {
    private let dataSource: CalendarDataSource
    private let mapper: ScheduleMapper
    private let upcommingMapper: UpcommingScheduleMapper

    init(
        dataSource: CalendarDataSource,
        mapper: ScheduleMapper,
        upcommingMapper: UpcommingScheduleMapper
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
        self.upcommingMapper = upcommingMapper
    }

    func getMonthlySchedule(year: Int, month: Int) -> AnyPublisher<[ScheduleVO], Error> {
        dataSource.getMonthlySchedule(year: year, month: month)
            .map { [weak self] dto in
                guard let self = self else { return [] }
                return dto.map { self.mapper.toVO(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func getUpcommingSchdule() -> AnyPublisher<[UpcommingScheduleVO], Error> {
        dataSource.getUpcommingSchedule()
            .map { [weak self] dto in
                guard let self = self else { return [] }
                return dto.map { self.upcommingMapper.toVO(dto: $0) }
            }
            .eraseToAnyPublisher()
    }

    func createSchedule(dto: ScheduleFormDTO) -> AnyPublisher<Void, Error> {
        dataSource.createSchedule(dto: dto)
    }

    func updateSchedule(scheduleId: Int, dto: ScheduleFormDTO) -> AnyPublisher<Void, Error> {
        dataSource.updateSchedule(scheduleId: scheduleId, dto: dto)
    }
}
