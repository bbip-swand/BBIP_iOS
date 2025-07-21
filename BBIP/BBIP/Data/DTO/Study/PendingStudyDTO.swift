//
//  PendingStudyDTO.swift
//  BBIP
//
//  Created by 이건우 on 11/19/24.
//

import Foundation

struct PendingStudyDTO: Decodable {
    let studyId: Int
    let studyName: String
    let totalWeeks: Int
    let studyWeek: Int
    let studyDate: String
    let startTime: String
    let endTime: String
    //let studyTime: StudyTime
    let leftDays: Int
    let place: String
}
