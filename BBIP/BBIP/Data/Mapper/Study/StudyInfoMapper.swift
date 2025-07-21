//
//  StudyInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/20/24.
//

import Foundation
import UIKit

struct StudyInfoMapper {
    func toVO(dto: StudyInfoDTO) -> StudyInfoVO {
        let studyTimes = dto.studyTimes.map { dtoTime in
            return StudyInfoVO.StudyTime(
                startTime: dtoTime.startTime,
                endTime: dtoTime.endTime
            )
        }
        
        // String -> enum 타입 변환
        let fieldEnum = StudyField(rawValue: dto.studyField) ?? .ETC
        
        // 해당 Int 값 지정
        let category = StudyCategory.from(int: fieldEnum.intValue) ?? .others
        
        // VO로 변환
        return StudyInfoVO(
            studyId: String(dto.studyId),
            studyName: dto.studyName,
            imageUrl: dto.studyImageUrl,
            category: category,
            totalWeeks: dto.totalWeeks,
            studyStartDate: dto.studyStartDate.replacingOccurrences(of: "-", with: "."),
            studyEndDate: dto.studyEndDate.replacingOccurrences(of: "-", with: "."),
            studyTimes: studyTimes,
            studyDescription: dto.studyDescription ?? "",
            studyContents: dto.studyContents ?? [],
            currentWeek: dto.currentWeek,
            isManager: dto.isManager
        )
    }
}

/// String <-> Int 형 변환 용도
enum StudyField: String, Codable, CaseIterable {
    case MAJOR
    case SELF_IMPROVEMENT
    case LANGUAGE
    case CERTIFICATION
    case INTERVIEW
    case DEVELOPMENT
    case DESIGN
    case HOBBY
    case ETC
    
    /// Enum case를 Int 값으로 변환합니다. (e.g., .MAJOR -> 0)
    ///
    /// 현재 케이스의 인덱스를 찾아 반환할 수 있습니다.
    var intValue: Int {
        return StudyField.allCases.firstIndex(of: self)!
    }
    
    /// Int 값을 사용하여 Enum case를 생성하는 초기화 메서드입니다. (e.g., 0 -> .MAJOR)
    ///
    /// - Parameter intValue: 변환하려는 정수 값 (0, 1, 2...)
    init?(intValue: Int) {
        // 유효하지 않은 인덱스에 대한 방어 코드
        guard intValue >= 0 && intValue < StudyField.allCases.count else {
            return nil
        }
        self = StudyField.allCases[intValue]
    }
}
