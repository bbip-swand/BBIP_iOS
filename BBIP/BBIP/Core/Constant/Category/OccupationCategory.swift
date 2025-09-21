//
//  OccupationCategory.swift
//  BBIP
//
//  Created by 이건우 on 11/11/24.
//

import Foundation

enum OccupationCategory: String {
    case undergraduate = "대학생"
    case graduate = "취준생"
    case employee = "직장인"
    case others = "기타"
    
    static let allOccupation: [OccupationCategory] = [
        .undergraduate,
        .graduate,
        .employee,
        .others
    ]
}

extension OccupationCategory {
    static func from(int: Int) -> OccupationCategory? {
        guard int >= 0 && int < allOccupation.count else{ return nil }
        return allOccupation[int]
    }
}
