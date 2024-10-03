//
//  CalendarVO.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import Foundation

struct CalendarVO {
    let date: Date
    let events: [CalendarHomeVO]
}

//userhome 및 캘린더뷰에서 사용될 캘린더VO (뷰에 뿌릴 거)
struct CalendarHomeVO{
    let scheduldId: String
    let studyName: String
    let scheduleTitle: String
    let isHomeView: Bool
    let icon: Int
    let leftDays: Int
    let startDate: Date
    let endDate: Date
}

//calendar 생성
struct CreateScheduleVO{
    let studyId: String
    let scheduleTitle: String
    let startDate: String
    let endDate: String
    let isHomeView: Bool
    let icon: Int
}

struct selectStudyVO{
    let studyId: String
    let studyName: String
}
