//
//  CalendarRepository.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation
import Combine

protocol CalendarRepository{
    func getScheduleYM(year:String, month:String) -> AnyPublisher<[CalendarHomeVO], Error>
    func getScheduleDate(date:String) -> AnyPublisher<[CalendarHomeVO],Error>
    func getUpcoming() -> AnyPublisher<[CalendarHomeVO], Error>
    func createSchedule(vo:CreateScheduleVO) -> AnyPublisher<Void,Error>
    func updateSchedule(scheduleId: String,vo:CreateScheduleVO) -> AnyPublisher<Void,Error> //일정 생성 , response 반환없음
    func getMyStudy() -> AnyPublisher<[selectStudyVO],Error>
}

final class CalendarRepositoryImpl: CalendarRepository{
    private let dataSource: CalendarDataSource
    private let getScheduleMapper: GetScheduleMapper
    private let createScheduleMapper: CreateScheduleMapper
    private let getMystudyMapper : GetMyStudyMapper
    
    init(
        dataSource: CalendarDataSource,
        getScheduleMapper: GetScheduleMapper,
        createScheduleMapper: CreateScheduleMapper,
        getMystudyMapper: GetMyStudyMapper
    ){
        self.dataSource = dataSource
        self.createScheduleMapper = createScheduleMapper
        self.getScheduleMapper = getScheduleMapper
        self.getMystudyMapper = getMystudyMapper
    }
    
    //MARK: -GET
    func getMyStudy() -> AnyPublisher<[selectStudyVO], any Error> {
        dataSource.getMyStudy()
            .map{dtos in
                return self.getMystudyMapper.toVOList(dtos: dtos)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: -GET
    func getScheduleYM(year: String, month: String) -> AnyPublisher<[CalendarHomeVO], any Error>{
        dataSource.getScheduleYM(year: year, month: month)
            .map{ dtos in
                return self.getScheduleMapper.toVOList(dtos: dtos)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: -GET
    func getScheduleDate(date: String) -> AnyPublisher<[CalendarHomeVO], any Error> {
        dataSource.getScheduleDate(date: date)
            .map{ dtos in
                return self.getScheduleMapper.toVOList(dtos: dtos)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: -GET
    func getUpcoming() -> AnyPublisher<[CalendarHomeVO], any Error> {
        dataSource.getUpcoming()
            .map{ dtos in
                return self.getScheduleMapper.toVOList(dtos: dtos)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: -POST
    func createSchedule(vo: CreateScheduleVO) -> AnyPublisher<Void, any Error> {
        let dto = createScheduleMapper.toDTO(vo: vo)
        print("dto: \(dto)")
        return dataSource.createSchedule(dto: dto)
            .eraseToAnyPublisher()
    }
    
    //MARK: -PUT
    func updateSchedule(scheduleId: String, vo: CreateScheduleVO) -> AnyPublisher<Void, any Error> {
        let dto = createScheduleMapper.toDTO(vo: vo)
        print("dto: \(dto)")
        return dataSource.updateSchedule(scheduleId: scheduleId, dto: dto)
            .eraseToAnyPublisher()
    }
}
