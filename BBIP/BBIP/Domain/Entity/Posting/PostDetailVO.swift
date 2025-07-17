//
//  PostDetailVO.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct PostDetailVO {
    let postId: Int
    let createdAt: String
    let writer: String
    let isManager: Bool
    let profileImageUrl: String?
    let studyName: String
    let title: String
    let content: String
    let postType: PostType
    let week: Int
    let commnets: [CommentVO]
}
