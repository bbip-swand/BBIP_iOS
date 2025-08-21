//
//  CreateStudyDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

struct CreateStudyInfoDTO: Encodable {
    let studyName: String
    let studyImageUrl: String
    let field: String
    let totalWeeks: Int
    let studyStartDate: String
    let studyEndDate: String
    let daysOfWeeks: [String]
    let studyTimes: [StudyTime]
    let studyDescription: String
    let studyContents: [String]
}

struct CreateStudyResponseDTO: Decodable {
    let studyId: Int
    let inviteCode: String
}
