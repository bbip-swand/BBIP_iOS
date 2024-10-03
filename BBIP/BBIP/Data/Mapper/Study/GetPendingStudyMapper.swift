//
//  GetPendingStudyMapper.swift
//  BBIP
//
//  Created by 조예린 on 10/4/24.
//

import Foundation

struct GetPendingStudyMapper {
    func toVO(dto: PendingRespDTO) -> PendingVO {
        print("\(dto)")
        let dateformatter = DateFormatter.customFormatter(format: "yyyy.mm.dd")
        
        return PendingVO(
            studyName: dto.studyName,
            studyTime: dto.studyTime.startTime + " ~ " + dto.studyTime.endTime,
            leftDays: dto.leftDays,
            place: dto.place.isEmpty ? "장소 미정" : dto.place,
            studyWeek: dto.studyWeek,
            totalweeks: dto.totalWeeks
        )
    }
}
