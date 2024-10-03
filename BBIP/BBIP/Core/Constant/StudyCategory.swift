//
//  StudyCategory.swift
//  BBIP
//
//  Created by 이건우 on 9/9/24.
//

import Foundation

enum StudyCategory: String {
    case majorSubject = "전공과목"
    case selfDevelopment = "자기계발"
    case language = "어학"
    case certification = "자격증"
    case interview = "면접"
    case development = "개발"
    case design = "디자인"
    case hobby = "취미"
    case others = "기타"
    
    static let allCategories: [StudyCategory] = [
        .majorSubject, .selfDevelopment, .language, .certification,
        .interview, .development, .design, .hobby, .others
    ]
}

extension StudyCategory {
    static func from(int: Int) -> StudyCategory? {
        guard int >= 0 && int < allCategories.count else {
            return nil
        }
        return allCategories[int]
    }
}



enum OccupationCategory: String{
    case undergraduate = "대학생"
    case graduate = "취준생"
    case employee = "직장인"
    case others = "기타"
    
    static let allOccupation: [OccupationCategory] = [
        .undergraduate, .graduate , .employee, .others
    ]
}

extension OccupationCategory {
    static func from(int:Int) -> OccupationCategory? {
        guard int >= 0 && int < allOccupation.count else{
            return nil
        }
        return allOccupation[int]
    }
}
