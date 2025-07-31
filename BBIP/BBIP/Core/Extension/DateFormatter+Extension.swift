//
//  DateFormatter+Extension.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

extension Date {
    // 날짜에서 9시간을 빼는 함수 (서버에서 받아온 시간을 사용할 때)
    func adjustedToKST() -> Date {
        return Calendar.current.date(byAdding: .hour, value: -9, to: self) ?? self
    }
}

extension DateFormatter {
    /// "yyyy-MM-dd" 형식의 DateFormatter
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" 형식의 ISO8601 DateFormatter
    static let iso8601WithMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXXX" 형식의 ISO8601 DateFormatter
    static let iso8601WithMilli9seconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXXX"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSSXZ" 형식의 ISO8601 DateFormatter
    static let iso8601WithMilli4seconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    /// "yyyy-MM-dd'T'HH:mm:ss" 형식의 ISO8601 DateFormatter
    static let iso8601WithSecond: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static func customFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    // 스터디 수정 사용 포맷 형식
    /// "HH:mm" 포맷 형식
    static let hhMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let createdAt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
}

/// int to 0요일
func dayName(for day: Int) -> String {
    switch day {
    case 0: return "월요일"
    case 1: return "화요일"
    case 2: return "수요일"
    case 3: return "목요일"
    case 4: return "금요일"
    case 5: return "토요일"
    case 6: return "일요일"
    default: return ""
    }
}
