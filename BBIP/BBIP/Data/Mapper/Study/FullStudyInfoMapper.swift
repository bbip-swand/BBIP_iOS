//
//  FullStudyInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/27/24.
//

import Foundation

struct FullStudyInfoMapper {
    func toVO(dto: FullStudyInfoDTO) -> FullStudyInfoVO {
        let studyTimes = dto.studyTimes.map { dtoTime in
            return StudyTime(
                startTime: dtoTime.startTime,
                endTime: dtoTime.endTime
            )
        }
        // 카테고리 변환
        // String -> enum 타입 변환
        let fieldEnum = StudyField(rawValue: dto.studyField) ?? .ETC
        
        // 해당 Int 값 지정
        let category = StudyCategory.from(int: fieldEnum.intValue) ?? .others
        //let category = StudyCategory.from(int: dto.studyField) ?? .others
        
        // 요일 변환
        // [String] -> [Int]
        let daysOfWeeks = dto.daysOfWeek.compactMap { let daysOfWeekEnum = DayOfWeek(rawValue: $0.rawValue)
            return daysOfWeekEnum?.intValue
        }
        
        var periodString: String {
            dto.studyStartDate.replacingOccurrences(of: "-", with: ".") +
            " ~ " +
            dto.studyEndDate.replacingOccurrences(of: "-", with: ".")
        }
        
        let studyMembers = dto.studyMemberDtos.map { member in
            let interests = member.interest.compactMap { StudyCategory.from(int: $0) }
            return StudyMemberVO(
                memberName: member.memberName,
                isManager: member.isManager,
                memberImageURL: member.memberImageUrl,
                interest: interests
            )
        }
        
        // VO로 변환
        return FullStudyInfoVO(
            studyId: String(dto.studyId),
            studyName: dto.studyName,
            studyImageURL: dto.studyImageUrl,
            studyField: category,
            totalWeeks: dto.totalWeeks,
            currentWeek: dto.currentWeek,
            currentWeekContent: dto.studyContents[dto.currentWeek - 1],
            studyPeriodString: periodString,
            daysOfWeek: daysOfWeeks,
            studyTimes: studyTimes,
            studyDescription: dto.studyDescription.isEmpty ? "-" : dto.studyDescription,
            studyContents: dto.studyContents,
            studyMembers: studyMembers,
            pendingDateStr: dto.pendingDate,
            inviteCode: dto.studyInviteCode,
            session: dto.session,
            isManager: dto.isManager,
            location: dto.place,
            studyStartDate: dto.studyStartDate,
            studyEndDate: dto.studyEndDate
        )
    }
}
