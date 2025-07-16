//
//  ModifyStudyInfoVO.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Foundation

struct ModifyStudyInfoVO {
    let studyName: String
    let studyImageUrl: String
    let field: StudyField
    let totalWeeks: Int
    let studyStartDate: String
    let studyEndDate: String
    let daysOfWeeks: [Int]
    let studyTimes: [StudyTime]
    let studyDescription: String
    let studyContents: [String]
}

extension ModifyStudyInfoVO{
    // 수정 관련 FullStudyInfoVO 변환 용도
    init (_ vo: FullStudyInfoVO) {
        self.studyName = vo.studyName
        self.studyImageUrl = vo.studyImageURL ?? ""
        self.field = StudyField(intValue: vo.studyField.hashValue) ?? .ETC
        self.totalWeeks = vo.totalWeeks
        self.studyStartDate = vo.studyStartDate
        self.studyEndDate = vo.studyEndDate
        self.daysOfWeeks = vo.daysOfWeek
        self.studyTimes = vo.studyTimes
        self.studyDescription = vo.studyDescription
        self.studyContents = vo.studyContents
    }
}
