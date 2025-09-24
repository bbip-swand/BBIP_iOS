//
//  UpdateAlertType.swift
//  BBIP
//
//  Created by 이건우 on 9/21/25.
//

struct AppUpdateConfig {
    static let appStoreAppId = "6670203690"
}

enum UpdateAlertType {
    case forceUpdate
    case featureUpdate
    case minorUpdate
    
    var title: String {
        switch self {
        case .forceUpdate:
            return "필수 업데이트 알림"
        case .featureUpdate:
            return "기능 업데이트 알림"
        case .minorUpdate:
            return "업데이트 알림"
        }
    }
    
    var message: String {
        switch self {
        case .forceUpdate:
            return "BBIP 최신 버전 업데이트가 필요해요!\n업데이트 후 서비스를 계속 이용할 수 있어요"
        case .featureUpdate:
            return "새로운 기능이 추가되었어요!\n지금 바로 업데이트 해보세요"
        case .minorUpdate:
            return "BBIP의 사용성이 개선되었어요!\n지금 바로 업데이트 해보세요"
        }
    }
}
