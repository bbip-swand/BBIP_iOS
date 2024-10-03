


import Foundation

struct PendingRespDTO: Decodable {
    let studyId: String
    let studyName: String
    let studyWeek: Int
    let startDate: String // String으로 수정하고 나중에 Date로 변환
    let studyTime: StudyTime
    let leftDays: Int
    let place: String
    let totalWeeks: Int
}

struct PendingVO {
    let studyName: String
    let studyTime: String
    let leftDays: Int
    let place: String
    let studyWeek: Int
    let totalweeks: Int
}
