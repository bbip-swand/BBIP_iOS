//
//  PostingAPI.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation
import Moya

enum PostingAPI {
    case getCurrentWeekPosting
    case getPostingDetail(postingId: String)                  // param
    case createPosting(dto: CreatePostingDTO)
    case createComment(postingId: String, content: String)  // param
    case getStudyPosting(studyId: String)
}

extension PostingAPI: BaseAPI {
    var path: String {
        switch self {
        case .getCurrentWeekPosting:
            return "/posting/recent"
        case .getPostingDetail(let postingId):
            return "/posting/details/\(postingId)"
        case .createPosting:
            return "/posting/create"
        case .createComment(let postingId, _):
            return "/posting/create/comment/\(postingId)"
        case .getStudyPosting(let studyId):
            return "/posting/all/\(studyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentWeekPosting, .getPostingDetail, .getStudyPosting:
            return .get
        case .createPosting, .createComment:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCurrentWeekPosting, .getPostingDetail, .getStudyPosting:
            return .requestPlain
        case .createPosting(let dto):
            return .requestJSONEncodable(dto)
        case .createComment(_, let content):
            let param = ["content": content]
            print(param)
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
