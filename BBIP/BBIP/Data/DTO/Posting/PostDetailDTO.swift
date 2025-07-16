//
//  PostDetailDTO.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Foundation

struct PostDetailDTO: Decodable {
    let postId: Int
    let studyName: String
    let writer: String
    let isManager: Bool?
    let profileImageUrl: String?
    let title: String
    let content: String
    let isNotice: Bool
    //let createdAt: Date
    let week: Int
    let comments: [CommentDTO]?
}
