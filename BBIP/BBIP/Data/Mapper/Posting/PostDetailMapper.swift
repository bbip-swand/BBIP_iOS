//
//  PostDetailMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct PostDetailMapper {
    func toVO(dto: PostDetailDTO) -> PostDetailVO {
        let dateFormatter = DateFormatter.createdAt
        let postType: PostType = dto.isNotice ? .notice : .normal
        
        let commentVOs = dto.comments?.map { commentDTO in
            CommentVO(commentId: commentDTO.commentId,
                      writer: commentDTO.writer,
                      content: commentDTO.content,
                      timeAgo: timeAgo(date: commentDTO.createdAt),
                      profileImageUrl: commentDTO.profileImageUrl,
                      isManager: commentDTO.isManager)
        } ?? []
        
        return PostDetailVO(
            postId: dto.postId,
            createdAt: dateFormatter.string(from: dto.createdAt.adjustedToKST()),
            writer: dto.writer,
            isManager: dto.isManager ?? false,
            profileImageUrl: dto.profileImageUrl,
            studyName: dto.studyName,
            title: dto.title,
            content: dto.content,
            postType: postType,
            week: dto.week,
            commnets: commentVOs
        )
    }
}

