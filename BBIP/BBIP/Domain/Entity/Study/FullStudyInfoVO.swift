//
//  FullStudyInfoVO.swift
//  BBIP
//
//  Created by 이건우 on 9/27/24.
//

import Foundation

/// 스터디 전체 정보 VO, 스터디 홈에서 사용
struct FullStudyInfoVO {
    let studyId: String
    let studyName: String
    let studyImageURL: String?
    let studyField: StudyCategory
    let totalWeeks, currentWeek: Int
    let currentWeekContent: String
    let studyPeriodString: String
    let daysOfWeek: [Int]
    let studyTimes: [StudyTime]
    let studyDescription: String
    let studyContents: [String]
    let studyMembers: [StudyMemberVO]
    
    let pendingDateStr: String
    let inviteCode: String
    
    let session: Int
    let isManager: Bool
    let location: String?
    
    // 수정 날짜 전달 용도
    let studyStartDate: String
    let studyEndDate: String
}


