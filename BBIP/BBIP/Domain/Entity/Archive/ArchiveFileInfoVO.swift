//
//  ArchivedFileInfoVO.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct ArchivedFileInfoVO: Equatable {
    let fileName: String
    let fileUrl: String
    let createdAt: String
    let fileSize: String
}

extension ArchivedFileInfoVO {
    static func placeholderMock() -> ArchivedFileInfoVO {
        return .init(
            fileName: "placeholder.pdf",
            fileUrl: "",
            createdAt: "0000. 00. 00",
            fileSize: "00.00"
        )
    }
}
