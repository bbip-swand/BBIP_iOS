//
//  StudyMemberDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/27/24.
//

import Foundation

/// 스터디 참여 멤버 정보 DTO
struct StudyMemberDTO: Decodable {
    let memberName: String
    let isManager: Bool
    let memberImageUrl: String?
    let interest: [Int]
}
