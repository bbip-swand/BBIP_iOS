//
//  ArchivedFileInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct ArchivedFileInfoMapper {
    func toVO(dto: [ArchivedFileInfoDTO]) -> [ArchivedFileInfoVO] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return dto.map { dtoItem in
            ArchivedFileInfoVO(
                fileName: dtoItem.fileName,
                fileUrl: "https://storage.googleapis.com" + dtoItem.fileUrl,
                createdAt: dateFormatter.string(from: dtoItem.createdAt),
                fileSize: dtoItem.fileSize
            )
        }
    }
}
