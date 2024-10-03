//
//  CalendarDTO.swift
//  BBIP
//
//  Created by 조예린 on 9/26/24.
//

import Foundation

//RequestDTO (post,put같은 DTO 사용)
struct CreateScheduleDTO : Encodable{
    let studyId: String
    let title: String
    let startDate: String
    let endDate: String
    let isHomeView: Bool
    let icon: Int
}

//ResponseDTO (월,일,upcoming조회)
struct ScheduleResponseDTO : Decodable{
    let scheduleId: String
    let studyName: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isHomeView: Bool
    let icon: Int
}

//select study
struct MyStudyResponseDTO : Decodable{
    let studyId: String
    let studyName: String
}
