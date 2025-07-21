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
    case getAttendRecord(studyId: String)                   // 출석 현황 조회
    case createCode(studyId: String, session: Int)       // 출석 코드 생성
    case enterCode(studyId: String, code: Int)              // 코드 입력
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStatus, .getAttendRecord:
            return .get
        case .createCode, .enterCode:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getStatus:
                return .requestPlain
            case .getAttendRecord(let studyId):
                let parameters = ["studyId": studyId]
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
