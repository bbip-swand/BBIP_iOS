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
            date: nextUpcomingStudyDate(startDateString: dto.studyStartDate, daysOfWeek: dto.daysOfWeek) ,
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
    
    // 스터디 임박 날짜 추출
    func nextUpcomingStudyDate(startDateString: String, daysOfWeek: [DayOfWeek]) -> String {
        let calendar = Calendar.current
        
        // 1. studyStartDate 문자열을 Date 객체로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            print("오류: studyStartDate 형식이 올바르지 않습니다.")
            return startDateString
        }
        
        // daysOfWeek(월=0...일=6) -> Calendar weekday(일=1...토=7) 체계 변환
        let targetWeekdays = Set(daysOfWeek.map { day -> Int in
            if day.intValue == 6 { return 1 }
            return day.intValue + 2
        })
        
        if targetWeekdays.isEmpty {
            return startDateString
        }
        
        // '오늘', '스터디 시작일' 중 기준 날짜 확이
        let today = calendar.startOfDay(for: Date())
        let searchStartDate = max(today, startDate)
        
        // 가장 인접한 요일 확인 후 반환 (일주일 탐색)
        for i in 0..<7 {
            guard let checkingDate = calendar.date(byAdding: .day, value: i, to: searchStartDate) else { continue }
            
            let weekday = calendar.component(.weekday, from: checkingDate)
            
            // 스터디 요일에 해당하는 경우
            if targetWeekdays.contains(weekday) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "MM월 dd일"
                outputDateFormatter.locale = Locale(identifier: "ko_KR")
                let formattedDate = outputDateFormatter.string(from: checkingDate)
                
                return formattedDate
            }
        }
        
        return startDateString
    }
}
