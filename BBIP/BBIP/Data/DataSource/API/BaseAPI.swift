//
//  BaseAPI.swift
//  BBIP
//
//  Created by 이건우 on 9/6/24.
//

import Foundation
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL {
        guard let baseURLString = Bundle.main.infoDictionary?["API_BASE_URL"] as? String,
              let url = URL(string: baseURLString) else {
            fatalError("❌ Invalid or missing API_BASE_URL in Info.plist")
        }
        
        return url
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
