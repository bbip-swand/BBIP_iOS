
import Foundation
import Moya

enum AttendanceAPI {
    case createCode(dto: CreateCodeDTO)
    case getStatus
    case enterCode(dto: EnterCodeDTO)
}

extension AttendanceAPI: BaseAPI{
    var path: String{
        switch self{
        case .createCode:
            return "/attendance/create"
        case .getStatus:
            return "/attendance/status"
        case .enterCode:
            return "/attendance/apply"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .createCode:
            return .post
        case .getStatus:
            return .get
        case .enterCode:
            return .post
        }
    }
    
    var task: Moya.Task{
        switch self{
        case .createCode(let dto):
            return .requestJSONEncodable(dto)
        
        case .getStatus:
            return .requestPlain
            
        case .enterCode(let dto):
            return .requestJSONEncodable(dto)
        }
    }
}
