//
//  ArchivedFileInfoDTO.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation

struct ArchivedFileInfoDTO: Decodable {
    let fileName: String
    let fileUrl: String
    let fileSize: String
    let createdAt: Date
}
