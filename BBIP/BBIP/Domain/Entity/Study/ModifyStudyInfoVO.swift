//
//  ModifyStudyInfoVO.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Foundation

struct ModifyStudyInfoVO {
    let studyId: String
    let studyName: String
    let studyImageUrl: String
    let field: StudyField
    let totalWeeks: Int
    let studyStartDate: String
    let studyEndDate: String
    let daysOfWeeks: [Int]
    let studyTimes: [StudyTime]
    let studyDescription: String
    var studyContents: [String]
}

extension ModifyStudyInfoVO{
    // 수정 관련 FullStudyInfoVO 변환 용도
    init (_ fullStudyInfoVO: FullStudyInfoVO) {
        self.studyId = fullStudyInfoVO.studyId
        self.studyName = fullStudyInfoVO.studyName
        self.studyImageUrl = fullStudyInfoVO.studyImageURL ?? ""
        self.field = fullStudyInfoVO.studyField.toStudyField
        self.totalWeeks = fullStudyInfoVO.totalWeeks
        self.studyStartDate = fullStudyInfoVO.studyStartDate
        self.studyEndDate = fullStudyInfoVO.studyEndDate
        self.daysOfWeeks = fullStudyInfoVO.daysOfWeek
        self.studyTimes = fullStudyInfoVO.studyTimes
        self.studyDescription = fullStudyInfoVO.studyDescription
        self.studyContents = fullStudyInfoVO.studyContents
    }
}
