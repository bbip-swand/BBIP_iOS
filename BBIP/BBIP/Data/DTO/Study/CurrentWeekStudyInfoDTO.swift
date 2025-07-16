//
//  CurrentWeekStudyInfoDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

struct CurrentWeekStudyInfoDTO: Decodable {
    var studyId: String
    var studyName: String
    var studyWeek: Int
    var studyImageUrl: String?
    var studyField: StudyField
    var studyDate: Date
    var dayOfWeek: Int
    var studyTime: StudyTime
    var studyContent: String
    var place: String
}
