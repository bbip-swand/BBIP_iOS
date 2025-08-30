//
//  AttendanceStatusMapper.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Foundation

struct AttendanceStatusMapper {
    func toVO(dto: AttendanceStatusDTO) -> AttendanceStatusVO {
        
        // 날짜 소수점 제외부분만 추출
        let trimmedStr = String(dto.startTime.prefix(19))
        let formatter = DateFormatter.iso8601WithSecond
        let startTime = formatter.date(from: trimmedStr) ?? Date()

        let currentTime = Date()
        let expirationTime = startTime.addingTimeInterval(TimeInterval(dto.ttl))
        let remainingTime = max(0, Int(expirationTime.timeIntervalSince(currentTime)) - 9 * 60 * 60)

        return AttendanceStatusVO(
            studyName: dto.studyName,
            studyId: dto.studyId,
            session: dto.session,
            remainingTime: remainingTime,
            code: dto.code ?? -1,
            isManager: dto.isManager,
            isAttended: dto.status
        )
    }
    
    func trimNanoseconds(from dateString: String) -> String {
        if let dotRange = dateString.range(of: ".") {
            let fractionalStart = dotRange.upperBound
            let endIndex = dateString.index(fractionalStart, offsetBy: 8, limitedBy: dateString.endIndex) ?? dateString.endIndex
            return String(dateString[..<fractionalStart]) + String(dateString[fractionalStart..<endIndex])
        }
        return dateString
    }
}
