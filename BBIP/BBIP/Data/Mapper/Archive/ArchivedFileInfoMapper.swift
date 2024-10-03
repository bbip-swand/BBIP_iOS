//
//  aaa.swift
//  BBIP
//
//  Created by 이건우 on 10/4/24.
//

import Foundation

struct ArchivedFileInfoMapper {
    func toVO(dto: [ArchivedFileInfoDTO]) -> [ArchivedFileInfoVO] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return dto.map { dtoItem in
            ArchivedFileInfoVO(
                fileName: dtoItem.fileName,
                fileUrl: dtoItem.fileUrl,
                createdAt: dateFormatter.string(from: dtoItem.createdAt),
                fileSize: dtoItem.fileSize
            )
        }
    }
}


