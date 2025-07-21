//
//  LoggerPlugin.swift
//  BBIP
//
//  Created by 최주원 on 7/14/25.
//

import Foundation
import Moya

final class LoggerPlugin: PluginType {

    // 1. 요청 보내기 직전에 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        
        var log = "----------------------------------------------------\n"
        log.append("🚀 [REQUEST] \(method) \(url)\n")
        
        // 헤더 내용
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("Headers: \(headers)\n")
        }
        
        // Body 내용
        if let body = httpRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            log.append("Body: \(bodyString)\n")
        }
        
        log.append("----------------------------------------------------\n")
        print(log)
    }
    
    // 2. 응답 받자마자 호출
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onSuceed(error.response, target: target, isFromError: true)
        }
    }
    
    // 응답 성공/실패 시 공통으로 호출될 로깅 함수
    private func onSuceed(_ response: Response?, target: TargetType, isFromError: Bool) {
        let request = response?.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response?.statusCode ?? 0
        
        var log = "----------------------------------------------------\n"
        if isFromError {
            log.append("🚨 [RESPONSE] \(statusCode) \(url)\n")
        } else {
            log.append("✅ [RESPONSE] \(statusCode) \(url)\n")
        }
        
        // 응답 데이터(JSON) 확인
        if let responseData = response?.data {
            if let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                log.append("Response Data:\n\(prettyPrintedString)\n")
            } else {
                log.append("Response Data: (JSON 형식이 아님)\n")
            }
        }
        
        log.append("----------------------------------------------------\n")
        print(log)
    }
}
