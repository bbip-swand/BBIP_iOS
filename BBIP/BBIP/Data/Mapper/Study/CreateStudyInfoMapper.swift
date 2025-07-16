//
//  CreateStudyInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

struct CreateStudyInfoMapper {
    /// CreateStudyInfoVO -> CreateStudyInfoDTO
    func toDTO(vo: CreateStudyInfoVO) -> CreateStudyInfoDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sessionTimeDateFormatter = DateFormatter()
        sessionTimeDateFormatter.dateFormat = "HH:mm"
        
        // StudyTime 변환
        let studyTimes = vo.studySessionArr.map { session in
            return StudyTime(
                startTime: sessionTimeDateFormatter.string(from: session.startTime!),
                endTime: sessionTimeDateFormatter.string(from: session.endTime!)
            )
        }
        // 요일 Int -> String 전환
        let daysOfWeek = vo.dayIndexArr.compactMap {
            let daysOfWeekEnum = DayOfWeek.init(intValue: $0)
            return daysOfWeekEnum?.rawValue
        }
        
        // 카테고리 Int -> String 전환
        let fieldEnum = StudyField(intValue: vo.category) ?? .ETC
        let fieldString = fieldEnum.rawValue
        
        // DTO 변환
        return CreateStudyInfoDTO(
            studyName: vo.name,
            studyImageUrl: vo.imageURL,
            field: fieldString,
            totalWeeks: vo.weekCount,
            studyStartDate: dateFormatter.string(from: vo.startDate),
            studyEndDate: dateFormatter.string(from: vo.endDate),
            daysOfWeeks: daysOfWeek,
            studyTimes: studyTimes,
            studyDescription: vo.description,
            studyContents: vo.weeklyContent.map { $0 ?? "" }
        )
    }
    
    /// ModifyStudyInfoVO -> CreateStudyInfoDTO
    func toDTO(vo: ModifyStudyInfoVO) -> CreateStudyInfoDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sessionTimeDateFormatter = DateFormatter()
        sessionTimeDateFormatter.dateFormat = "HH:mm"
        
        // 요일 Int -> String 전환
        let daysOfWeek = vo.daysOfWeeks.compactMap {
            let daysOfWeekEnum = DayOfWeek.init(intValue: $0)
            return daysOfWeekEnum?.rawValue
        }
        
        
        // DTO 변환
        return CreateStudyInfoDTO(
            studyName: vo.studyName,
            studyImageUrl: vo.studyImageUrl,
            field: vo.field.rawValue,
            totalWeeks: vo.totalWeeks,
            studyStartDate: vo.studyStartDate,
            studyEndDate: vo.studyEndDate,
            daysOfWeeks: daysOfWeek,
            studyTimes: vo.studyTimes,
            studyDescription: vo.studyDescription,
            studyContents: vo.studyContents
        )
    }
}

enum DayOfWeek: String, Codable, CaseIterable {
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    case SUNDAY
    
    /// 현재 케이스의 인덱스를 찾아 반환
    var intValue: Int {
        return DayOfWeek.allCases.firstIndex(of: self)!
    }
    
    // Int -> enum값 반환
    init?(intValue: Int) {
        // 유효하지 않은 인덱스에 대한 방어 코드
        guard intValue >= 0 && intValue < StudyField.allCases.count else {
            return nil
        }
        self = DayOfWeek.allCases[intValue]
    }
}

