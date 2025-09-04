//
//  PendingStudyMapper.swift
//  BBIP
//
//  Created by 이건우 on 11/19/24.
//

import Foundation

struct PendingStudyMapper {
    func toVO(dto: PendingStudyDTO) -> PendingStudyVO {
        return PendingStudyVO(
            studyId: String(dto.studyId),
            studyName: dto.studyName,
            studyWeek: dto.studyWeek,
            studyTime: dto.startTime + " - " + dto.endTime,
            leftDays: dto.leftDays,
            place: dto.place.isEmpty ? "장소 미정" : dto.place,
            totalWeeks: dto.totalWeeks
        )
    }
}
