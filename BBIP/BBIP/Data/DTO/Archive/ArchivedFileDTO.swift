//
//  ArchivedFileDTO.swift
//  BBIP
//
//  Created by 이건우 on 10/4/24.
//

import Foundation

struct ArchivedFileInfoDTO: Decodable {
    let fileName: String
    let fileUrl: String
    let createdAt: Date
    let fileSize: String
}
