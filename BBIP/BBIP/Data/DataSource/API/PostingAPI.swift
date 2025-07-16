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
    case getPostingDetail(postingId: Int)                  // param
    case createPosting(dto: CreatePostingDTO)
    case createComment(postingId: Int, content: String)  // param
    case getStudyPosting(studyId: String)
    case editPosting(postingID: String, dto: CreatePostingDTO)
    case deletePost(postId: Int)
    case deleteComment(commentId: Int)
}

extension PostingAPI: BaseAPI {
    var path: String {
        switch self {
            case .getCurrentWeekPosting:
                return "/post"
            case .getPostingDetail(let postingId):
                return "/post/\(postingId)"
            case .createPosting:
                return "/post"
            case .createComment(let postingId, _):
                return "/post/\(postingId)/comment"
            case .getStudyPosting(let studyId):
                return "/post/study/\(studyId)"
            case .editPosting(let postingId, _):
                return "/post/\(postingId)"
            case .deletePost(let postId):
                return "/post/\(postId)"
            case .deleteComment(let commentId):
                return "/post/comment/\(commentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getCurrentWeekPosting, .getPostingDetail, .getStudyPosting:
                return .get
            case .createPosting, .createComment:
                return .post
            case .editPosting:
                return .put
            case .deletePost, .deleteComment:
                return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getCurrentWeekPosting, .getPostingDetail, .getStudyPosting, .deletePost, .deleteComment:
            return .requestPlain
            case .createPosting(let dto), .editPosting(_, let dto):
            return .requestJSONEncodable(dto)
        case .createComment(_, let content):
            let param = ["content": content]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
