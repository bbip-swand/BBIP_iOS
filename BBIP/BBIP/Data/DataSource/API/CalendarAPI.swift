//
//  CalendarAPI.swift
//  BBIP
//
//  Created by 조예린 on 9/26/24.
//

import Foundation
import Moya

enum CalendarAPI {
    case getScheduleYM(year:String, month:String) //path param
    case getScheduleDate(date: String) //path param
    case getUpcoming
    case createSchedule(dto:CreateScheduleDTO)
    case updateSchedule(scheduleId: String, dto: CreateScheduleDTO) //path param
    case getMyStudy
}

extension CalendarAPI: BaseAPI {
    var path: String{
        switch self{
        case .getScheduleYM(let year, let month):
            return "/calendar/list"
            
        case .getScheduleDate(let date):
            return "/calendar/list"
            
        case .getUpcoming:
            return "/calendar/schedule/upcoming"
            
        case .createSchedule:
            return "/calendar/create"
            
        case .updateSchedule(let scheduleId, _):
            return "/calendar/update/\(scheduleId)"
            
        case .getMyStudy:
            return "/study/my-study"
        }
    }
    
    var method: Moya.Method{
        switch self{
        case .getScheduleYM, .getScheduleDate, .getUpcoming , .getMyStudy:
            return .get
        case .createSchedule:
            return .post
        case .updateSchedule:
            return .put
        }
    }
    
    var task: Moya.Task{
        switch self{
        case .getUpcoming , .getMyStudy :
            return .requestPlain
            
        case .getScheduleYM(let year, let month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: URLEncoding.queryString
            )
            
        case .getScheduleDate(let date):
            return .requestPlain
            
        case .createSchedule(let dto):
            return .requestJSONEncodable(dto)
            
        case .updateSchedule(_, let dto):
            return .requestJSONEncodable(dto)
        }
    }
}
