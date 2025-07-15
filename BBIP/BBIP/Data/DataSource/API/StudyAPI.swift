//
//  StudyAPI.swift
//  BBIP
//
//  Created by 이건우 on 9/20/24.
//

import Foundation
import Moya

enum StudyAPI {
    case getThisWeekStudy
    case getOngoingStudy
    case getFinishedStudy
    case getFullStudyInfo(studyId: String)      // param
    case getInviteInfo(inviteCode: String)      // param
    case createStudy(dto: CreateStudyInfoDTO)
    case joinStudy(studyId: String)             // param
    case editStudyLocation(studyId: String, session: Int, location: String)
    case getPendingStudy
    case deleteStudy(studyId: String)
    case editStudyInfo(studyId: String, dto: CreateStudyInfoDTO)
}

extension StudyAPI: BaseAPI {
    var path: String {
        switch self {
            case .getThisWeekStudy:
                return "/study"
            case .getOngoingStudy:
                return "/study"
            case .getFinishedStudy:
                return "/study"
            case .getFullStudyInfo(let studyId):
                return "/study/\(studyId)"
            case .getInviteInfo:
                return "/study/invite-info"
            case .createStudy:
                return "/study"
            case .joinStudy(let studyId):
                return "/study/join/\(studyId)"
            case .editStudyLocation(let studyId, _, _):
                return "/study/\(studyId)/place"
            case .getPendingStudy:
                return "/study/pending"
            case .deleteStudy(let studyId):
                return "/study/\(studyId)"
            case .editStudyInfo(let studyId, _):
                return "/study/\(studyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getThisWeekStudy, .getOngoingStudy, .getFinishedStudy, .getFullStudyInfo, .getInviteInfo, .getPendingStudy:
                return .get
            case .createStudy, .joinStudy:
                return .post
            case .editStudyInfo:
                return .put
            case .deleteStudy:
                return .delete
            case .editStudyLocation :
                return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getFullStudyInfo, .getPendingStudy:
                return .requestPlain
                
            case .getThisWeekStudy:
                let param = ["status" : "week"]
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            case .getOngoingStudy:
                let param = ["status" : "ongoing"]
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            case .getFinishedStudy:
                let param = ["status" : "finished"]
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            case .getInviteInfo(let inviteCode):
                let param = ["inviteCode" : inviteCode]
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
                
            case .createStudy(let dto), .editStudyInfo(_, let dto):
                return .requestJSONEncodable(dto)
                
            case .joinStudy(let studyId):
                let param = ["studyId": studyId]
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
                
            case .editStudyLocation(_, let session, let location):
                let param = ["session" : session, "place" : location] as [String : Any]
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            case .deleteStudy(let studyId):
                let param = ["studyId": studyId]
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
}


