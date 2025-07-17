//
//  CreatePostingDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation

struct CreatePostingDTO: Encodable {
    let studyId: Int
    let title: String
    let week: Int
    let content: String
    let isNotice: Bool
}
