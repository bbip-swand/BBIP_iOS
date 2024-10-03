//
//  GetPendingStudyMapper.swift
//  BBIP
//
//  Created by 조예린 on 10/4/24.
//

import Foundation

struct GetPendingStudyMapper {
    func toVO(dto: PendingRespDTO) -> PendingVO{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        

        return PendingVO(
            studyName: dto.studyName,
            studyTime: dto.studyTime,
            leftDays: dto.leftDays,
            place: dto.place
        )
    }
}
