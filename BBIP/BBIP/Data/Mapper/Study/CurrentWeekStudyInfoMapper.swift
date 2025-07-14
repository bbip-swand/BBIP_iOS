//
//  CurrentWeekStudyInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

struct CurrentWeekStudyInfoMapper {
    // api 수정 후 반환값 StudyInfoDTO로 통합
    // CurrentWeekStudyInfoDTO -> StudyInfoDTO
    func toVO(dto: StudyInfoDTO) -> CurrentWeekStudyInfoVO {
        
        // String -> enum 타입 변환
        let fieldEnum = StudyField(rawValue: dto.studyField) ?? .ETC
        
        // 해당 Int 값 지정
        let category = StudyCategory.from(int: fieldEnum.intValue) ?? .others
        
        return CurrentWeekStudyInfoVO(
            studyId: String(dto.studyId),
            imageUrl: dto.studyImageUrl,
            title: dto.studyName,
            category: category,
            currentStudyRound: dto.currentWeek,
            currentStudyDescription: dto.studyContent,
            date: dateFormatter(dto.studyStartDate),
            time: dto.studyTimes[0].startTime + " ~ " + dto.studyTimes[0].endTime,
            location: dto.place ?? "미정"
        )
    }
    
    // "YYYY-MM-DD" -> "MM월 dd일" 형태로 변환
    func dateFormatter(_ dateString: String) -> String {
        // 입력값 형식 지정
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        inputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        // Date 타입으로 변환
        guard let dateObject = inputDateFormatter.date(from: dateString) else { return dateString }
        
        // 반환 형식 지정
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM월 dd일"
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = outputDateFormatter.string(from: dateObject)
        
        return formattedDate
        
    }
}
