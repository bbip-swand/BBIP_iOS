//
//  CurrentWeekPostMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation

struct RecentPostMapper {
    func toVO(dto: [PostDTO]) -> RecentPostVO {
        return dto.map { dtoItem in
            let postType: PostType = dtoItem.isNotice ? .notice : .normal
            
            return PostVO(
                postId: dtoItem.postId,
                createdAt: dtoItem.createdAt,
                writer: dtoItem.writer,
                studyName: dtoItem.studyName,
                title: dtoItem.title,
                content: dtoItem.content,
                postType: postType,
                week: dtoItem.week
            )
        }
    }
}
