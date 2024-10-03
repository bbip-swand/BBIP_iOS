//
//  AttendanceDTO.swift
//  BBIP
//
//  Created by 조예린 on 9/23/24.
//

import Foundation

//Client to Server
struct CreateCodeDTO: Encodable{
    let studyId: String
    let session: Int
}

struct EnterCodeDTO: Encodable{
    let studyId: String
    let code: Int
}

//Server to Client
struct CreateCodeResponseDTO: Decodable{
    let code: Int
}

struct GetStatusResponseDTO: Decodable{
    let studyName: String
    let studyId: String
    let session: Int
    let startTime: String
    let ttl: Int
    let code: Int?
    let isManager: Bool
    let status: Bool
}

struct GetAttendRecordDTO: Decodable{
    let session: Int
    let userName: String
    let profileImageUrl: String?
    let status: AttendanceStatus
}
