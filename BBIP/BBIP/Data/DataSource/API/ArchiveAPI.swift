//
//  ArchiveAPI.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation
import Moya

enum ArchiveAPI {
    case getArchivedFile(studyCode: String)
}

extension ArchiveAPI: BaseAPI {
    var path: String {
        switch self {
        case .getArchivedFile:
            return "/archive"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArchivedFile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .getArchivedFile(let studyCode):
                let param = ["studyCode" : studyCode]
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
