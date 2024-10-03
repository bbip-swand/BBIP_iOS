//
//  CalendarMapper.swift
//  BBIP
//
//  Created by 조예린 on 9/26/24.
//

import Foundation
import UIKit


//studyresponsedto -> studyvo
struct GetMyStudyMapper{
    func toVO(dto: MyStudyResponseDTO) -> selectStudyVO{
        let vo = selectStudyVO(
            studyId: dto.studyId, studyName: dto.studyName
        )
        return vo
    }
    
    func toVOList(dtos: [MyStudyResponseDTO]) -> [selectStudyVO]{
        print("toVOList: \(dtos.map {toVO(dto:$0)})")
        return dtos.map{toVO(dto:$0)}
    }
}



//ResponseDto -> CalendarHomeVO(캘린더뷰, 유저홈뷰에서 쓸 내용)
struct GetScheduleMapper{
    func toVO(dto: ScheduleResponseDTO) -> CalendarHomeVO{
        // DateFormatter 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        // 현재 날짜
        let currentDate = Date()
        
        // D-Day 계산 (startDate와 현재 날짜 간의 차이 계산)
        let calendar = Calendar.current
        let startDate = dto.startDate
        
        // 날짜 차이 계산 (D-day)
        let leftDays = calendar.dateComponents([.day], from: currentDate, to: startDate).day ?? 0
        
       let vo = CalendarHomeVO(
            scheduldId: dto.scheduleId,
            studyName: dto.studyName,
            scheduleTitle: dto.title,
            isHomeView: dto.isHomeView,
            icon:dto.icon,
            leftDays: leftDays,
            startDate: dto.startDate,
            endDate:dto.endDate
        )
        return vo
    }
    
    func toVOList(dtos: [ScheduleResponseDTO]) -> [CalendarHomeVO] {
        print("toVOList: \(dtos.map { toVO(dto: $0) })")
        return dtos.map { toVO(dto: $0) }
    }
}

//CreateScheduleVO -> RequestDTO
struct CreateScheduleMapper{
    func toDTO(vo:CreateScheduleVO) -> CreateScheduleDTO{
        return CreateScheduleDTO(studyId: vo.studyId, title: vo.scheduleTitle, startDate: vo.startDate, endDate: vo.endDate, isHomeView: vo.isHomeView, icon: vo.icon)
    }
}
