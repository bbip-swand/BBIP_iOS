//
//  PostVO.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation

enum PostType {
    case notice // 공지 글
    case normal // 일반 글
}

/// UserHome 화면에서 보이는 게시판
typealias RecentPostVO = [PostVO]

struct PostVO: Equatable, Hashable {
    let postId: Int
    let createdAt: Date
    let writer: String
    let studyName: String
    let title: String
    let content: String
    let postType: PostType
    let week: Int
}

extension PostVO {
    static func placeholderVO() -> PostVO {
        return PostVO.init(
            postId: 0,
            createdAt: Date(),
            writer: "",
            studyName: "placeholder",
            title: "placeholder",
            content: "placeholder",
            postType: .normal, 
            week: 0
        )
    }
}
