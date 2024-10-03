//
//  AttendanceVO.swift
//  BBIP
//
//  Created by 조예린 on 9/25/24.
//

import Foundation


//하나의 AttendVO에서 -> CreateCodeDTO, EnterCodeDTO
struct AttendVO{
    let studyId: String
    let session: Int
    let code: Int
}

struct GetStatusVO{
    let studyName: String
    let studyId: String
    let session: Int
    let startTime: Date
    let ttl: Int
    let code: Int?
    let isManager: Bool
    let status: Bool
}

struct getAttendRecordVO{
    let session: Int
    let userName: String
    let profileImageUrl: String
    let status: AttendanceStatus
}

enum AttendanceStatus: String, Decodable {
    case attended = "ATTENDED"
    case absent = "ABSENT"
}
