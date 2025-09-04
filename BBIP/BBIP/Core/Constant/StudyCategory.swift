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
    
    /// StudyCategory를 StudyField로 변환하는 프로퍼티
    var toStudyField: StudyField {
        switch self {
        case .majorSubject: return .MAJOR
        case .selfDevelopment: return .SELF_IMPROVEMENT
        case .language: return .LANGUAGE
        case .certification: return .CERTIFICATION
        case .interview: return .INTERVIEW
        case .development: return .DEVELOPMENT
        case .design: return .DESIGN
        case .hobby: return .HOBBY
        case .others: return .ETC
        }
    }
    
    var intValue: Int {
        switch self {
            case .majorSubject: return 0
            case .selfDevelopment: return 1
            case .language: return 2
            case .certification: return 3
            case .interview: return 4
            case .development: return 5
            case .design: return 6
            case .hobby: return 7
            case .others: return 8
        }
    }
}
