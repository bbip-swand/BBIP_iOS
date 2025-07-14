//
//  StudyInfoDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/20/24.
//

import Foundation

/// 스터디 기본 정보 DTO
/// ex) ongoingStudy...
struct StudyInfoDTO: Decodable {
    let studyId: Int
    let studyName: String
    let isManager: Bool
    let totalWeeks: Int
    let currentWeek: Int
    let studyImageUrl: String?
    let studyField: String
    let studyStartDate: String
    let studyEndDate: String
    let daysOfWeek: [DayOfWeek]
    let studyTimes: [StudyTime]
    let studyDescription: String?
    let studyContents: [String]?
    let place: String?
    let studyContent: String
}

struct BaseResponseDTO<T: Decodable>: Decodable {
    let message: String
    let data: T
}
