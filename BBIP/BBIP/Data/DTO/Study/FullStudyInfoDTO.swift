//
//  StudyFullInfoDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/27/24.
//

import Foundation

/// 스터디 전체 정보 DTO
struct FullStudyInfoDTO: Decodable {
    let studyId: Int
    let studyName: String
    let studyImageUrl: String?
    let studyField: String
    let isManager: Bool
    let totalWeeks, currentWeek: Int
    let session: Int
    let pendingDate: String
    let studyStartDate, studyEndDate: String
    let daysOfWeek: [DayOfWeek]
    let studyTimes: [StudyTime]
    let studyDescription: String
    let studyContents: [String]
    let studyMemberDtos: [StudyMemberDTO]
    let studyInviteCode: String
    let place: String?
}
