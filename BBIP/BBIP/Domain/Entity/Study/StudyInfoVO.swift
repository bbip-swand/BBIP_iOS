//
//  StudyInfoVO.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

/// 앱 전반적으로 사용되는 스터디 정보 VO
/// 스터디 스위치 뷰 & 마이페이지 나의스터디에서 사용
struct StudyInfoVO {
    let studyId: String
    let studyName: String
    let imageUrl: String?
    let category: StudyCategory
    let totalWeeks: Int
    let studyStartDate: String
    let studyEndDate: String
    let studyTimes: [StudyTime]
    let studyDescription: String
    let studyContents: [String]
    let currentWeek: Int
    
    struct StudyTime: Codable {
        let startTime: String
        let endTime: String
    }
}

