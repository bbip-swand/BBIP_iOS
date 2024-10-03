
//
//  PostDetailMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct PostDetailMapper {
    func toVO(dto: PostDTO) -> PostDetailVO {
        let dateFormatter = DateFormatter.customFormatter(format: "MM/dd HH:mm")
        let postType: PostType = dto.isNotice ? .notice : .normal
        
        let commentVOs = dto.comments?.map { commentDTO in
            CommentVO(writer: commentDTO.writer,
                      content: commentDTO.content,
                      timeAgo: timeAgo(date: commentDTO.createdAt),
                      profileImageUrl: commentDTO.profileImageUrl,
                      isManager: commentDTO.isManager)
        } ?? []
        
        return PostDetailVO(
            postId: dto.postingId,
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
