//
//  AttendanceAPI.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Foundation
import Moya

enum AttendanceAPI {
    case getStatus                                          // 출석 진행 중인지 여부 확인
    case getAttendRecord(studyId: String)                   // 출석 현황 조회 (참여/불참 멤버)
    case createCode(studyId: String, session: Int)          // 출석 코드 생성
    case enterCode(studyId: String, code: Int)              // 코드 입력
    case getStudyStatus(studyId: String)                    // 특정 스터디 출석 인증 존재 여부를 확인
}

extension AttendanceAPI: BaseAPI {
    var path: String {
        switch self {
            case .createCode:
                return "/attendances"
            case .getStatus:
                return "/attendances"
            case .enterCode:
                return "/attendances/verification"
            case .getAttendRecord(let studyId):
                return "/attendances/\(studyId)"
            case .getStudyStatus(let studyId):
                return "/attendances/attendance/\(studyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getStatus, .getAttendRecord, .getStudyStatus:
                return .get
            case .createCode, .enterCode:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getStatus, .getStudyStatus, .getAttendRecord:
                return .requestPlain
            case .createCode(let studyId, let session):
                let parameters: [String: Any] = [
                    "studyId": studyId,
                    "session": session
                ]
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
                
            case .enterCode(let studyId, let code):
                let parameters: [String: Any] = [
                    "studyId": studyId,
                    "code": code
                ]
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
