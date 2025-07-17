//
//  UserAPI.swift
//  BBIP
//
//  Created by 이건우 on 9/7/24.
//

import Moya

enum UserAPI {
    case signUp(dto: SignUpRequestDTO)
    case resign
    case createInfo(dto: UserInfoDTO)
    case updateInfo(dto: UserInfoDTO)
    case postFCMToken(token: String)
    case checkNewUser
    case getUserInfo
}

extension UserAPI: BaseAPI {
    var path: String {
        switch self {
        case .signUp:
            return "/auth/signup/apple"
        case .resign:
            return "/auth/resign/apple"
        case .createInfo:
            return "/users/info"
        case .updateInfo:
            return "/users/info"
        case .postFCMToken:
            return "/users/fcmToken"
        case .checkNewUser:
            return "/users/me/new-status"
        case .getUserInfo:
            return "/users/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .resign, .createInfo :
            return .post
        case .updateInfo, .postFCMToken:
            return .put
        case .checkNewUser, .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let dto):
            return .requestJSONEncodable(dto)
        case .resign, .checkNewUser, .getUserInfo:
            return .requestPlain
        case .createInfo(let dto):
            return .requestJSONEncodable(dto)
        case .updateInfo(let dto):
            return .requestJSONEncodable(dto)
        case .postFCMToken(token: let token):
            let param = ["fcmToken" : token]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
}
