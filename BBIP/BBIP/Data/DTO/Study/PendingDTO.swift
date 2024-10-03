//
//  PendingDTO.swift
//  BBIP
//
//  Created by 조예린 on 10/3/24.
//

import Foundation

struct PendingRespDTO : Decodable {
    let studyId: String
    let studyName: String
    let studyWeek: Int
    let startDate: Date
    let studyTime: String
    let leftDays: Int
    let place: String
}

struct PendingVO {
    let studyName: String
    let studyTime: String
    let leftDays: Int
    let place: String
}
