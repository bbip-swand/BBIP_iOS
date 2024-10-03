//
//  AttendanceMapper.swift
//  BBIP
//
//  Created by 조예린 on 9/25/24.
//

import Foundation
import UIKit

struct CreateCodeMapper {
    func toDTO(vo:AttendVO) -> CreateCodeDTO{
        return CreateCodeDTO(studyId: vo.studyId, session: vo.session)
    }
}

struct EnterCodeMapper{
    func toDTO(vo:AttendVO) -> EnterCodeDTO{
        return EnterCodeDTO(studyId: vo.studyId, code: vo.code)
    }
}

struct GetStatusMapper{
    func toVo(dto:GetStatusResponseDTO) -> GetStatusVO{
        print("StartTime: \(dto.startTime)")
        
        // 1. 먼저 ISO 8601 형식의 문자열을 Date로 변환 (UTC 기준)
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 형식
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC로 설정
        
        // ISO 8601 형식에서 Date로 변환
        let startTimeUTC: Date = isoDateFormatter.date(from: dto.startTime) ?? Date()
        
        // 2. UTC에서 9시간을 빼서 한국 시간대 기준으로 변환된 Date 생성
        let nineHours: TimeInterval = 0// 9시간을 초 단위로 변환
        let startTimeKST = startTimeUTC.addingTimeInterval(nineHours)
        
        let code = dto.code ?? 0
        
        
        print("StartTime in KST: \(startTimeUTC)")

        return GetStatusVO(
            studyName: dto.studyName,
            studyId: dto.studyId,
            session: dto.session,
            startTime: startTimeUTC,
            ttl: dto.ttl,
            code: code,
            isManager: dto.isManager,
            status: dto.status
        )
    }
}

struct GetAttendRecordMapper{
    
    func toVO(dto:GetAttendRecordDTO) -> getAttendRecordVO{
        let vo = getAttendRecordVO(
            session: dto.session,
            userName: dto.userName,
            profileImageUrl: dto.profileImageUrl ?? "profile_default",
            status: dto.status)
        print("Mapping DTO: \(dto) to VO")
        print("Mapping VO: \(vo)")
        print("")
        
        return vo
    }
    
    func toVOList(dtos: [GetAttendRecordDTO]) -> [getAttendRecordVO] {
        print("toVOList: \(dtos.map { toVO(dto: $0) })")
        return dtos.map { toVO(dto: $0) }
    }
}
