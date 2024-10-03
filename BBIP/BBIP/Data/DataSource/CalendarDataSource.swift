//
//  CalendarDataSource.swift
//  BBIP
//
//  Created by 조예린 on 9/26/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class CalendarDataSource{
    private let provider = MoyaProvider<CalendarAPI>(plugins: [TokenPlugin()])
    
    //MARK: -GET
    func getScheduleYM(year: String, month: String) -> AnyPublisher<[ScheduleResponseDTO], Error>{
        provider.requestPublisher(.getScheduleYM(year: year, month: month))
            .tryMap{ response in
                guard(200...299).contains(response.statusCode) else{
                    throw NSError(
                        domain: "Fail getScheduleYM",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[GetScheduleYM] getScheduleYM() failed with schedule \(response.statusCode)"]
                    )
                }
                return response.data
            }
            .decode(type: [ScheduleResponseDTO].self, decoder:JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError{error in return error}
            .eraseToAnyPublisher()
    }
        
    //MARK: -GET
        func getScheduleDate(date:String) -> AnyPublisher<[ScheduleResponseDTO], Error>{
            provider.requestPublisher(.getScheduleDate(date: date))
                .tryMap{response in
                    guard (200...299).contains(response.statusCode) else{
                        throw NSError(
                            domain:"Fail getScheduleDate",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "[GetScheduleDate] getScheduleDate() failed with schedule \(response.statusCode)"]
                        )
                    }
                    return response.data
                }
                .decode(type: [ScheduleResponseDTO].self,decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
                .mapError{error in return error}
                .eraseToAnyPublisher()
        }
    
    //MARK: -GET
    func getUpcoming() -> AnyPublisher<[ScheduleResponseDTO], Error>{
        provider.requestPublisher(.getUpcoming)
            .tryMap{response in
                guard(200...299).contains(response.statusCode) else{
                    throw NSError(
                        domain: "Get Upcoming Schedule Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[GetUpcoming] getUpcoming() failed with status code \(response.statusCode)"]
                    )
                }
                return response.data
            }
            .decode(type: [ScheduleResponseDTO].self, decoder:JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError{error in return error}
            .eraseToAnyPublisher()
    }
    
    //MARK: -Get
    func getMyStudy() -> AnyPublisher<[MyStudyResponseDTO], Error>{
        provider.requestPublisher(.getMyStudy)
            .tryMap{ response in
                guard (200...299).contains(response.statusCode) else{
                    throw NSError(
                        domain: "GetMystudy Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey:"[getmystudy] getmystudy() failed with status code \(response.statusCode)"]
                    )
                }
                return response.data
            }
            .decode(type:[MyStudyResponseDTO].self, decoder: JSONDecoder())
            .mapError{error in return error}
            .eraseToAnyPublisher()
    }
    
    //MARK: -POST
    func createSchedule(dto: CreateScheduleDTO) -> AnyPublisher<Void,Error>{
        provider.requestPublisher(.createSchedule(dto: dto))
            .tryMap{response in
                guard(200...299).contains(response.statusCode) else{
                    throw NSError(
                        domain: "createSchedule Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[createSchedule] createSchedule() failed with status code \(response.statusCode)"]
                    )
                }
                return ()
            }
            .mapError{error in return error}
            .eraseToAnyPublisher()
    }
    
    //MARK: -PUT
    func updateSchedule(scheduleId: String,dto: CreateScheduleDTO) -> AnyPublisher<Void,Error>{
        provider.requestPublisher(.createSchedule(dto: dto))
            .tryMap{ response in
                guard(200...299).contains(response.statusCode) else{
                    throw NSError(
                        domain: "updateSchedule Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[updateSchedule] updateSchedule() failed with status code \(response.statusCode)"]
                    )
                }
                return ()
            }
            .mapError{error in return error}
            .eraseToAnyPublisher()
    }
    
}
