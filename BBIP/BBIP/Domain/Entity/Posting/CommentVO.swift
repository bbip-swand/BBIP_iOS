//
//  CommentVO.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct CommentVO {
    let commentId: Int
    let writer: String
    let content: String
    let timeAgo: String
    let profileImageUrl: String?
    let isManager: Bool
}

extension CommentVO {
    static func placeholderMock() -> CommentVO {
        return .init(
            commentId: 0,
            writer: "000",
            content: "content placeholder",
            timeAgo: "00시간 전",
            profileImageUrl: "",
            isManager: false
        )
    }
}
