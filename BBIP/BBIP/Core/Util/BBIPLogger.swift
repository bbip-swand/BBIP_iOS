//
//  BBIPLogger.swift
//  BBIP
//
//  Created by 이건우 on 6/29/25.
//

import Foundation
import os

// MARK: - AppLogger

/// 앱 전반에서 사용할 통합 로깅 유틸리티입니다.
/// DEBUG 환경에선 `print`, RELEASE 환경에선 `OSLog`를 통해 로그를 출력합니다.
enum BBIPLogger {
    
    // MARK: - Log Category
    
    /// 로그를 필터링하기 위한 카테고리입니다.
    enum LogCategory {
        /// UI 관련
        case ui
        
        /// 네트워킹 관련
        case network
        
        /// DTO, VO 관련
        case model
        
        /// viewModel 관련 로직
        case viewModel
        
        /// Feature 주요 로직
        case feature(featureName: String)
        
        case `default`
        
        var rawValue: String {
            switch self {
            case .ui: return "UI"
            case .network: return "Network"
            case .model: return "Model"
            case .viewModel: return "ViewModel"
            case .feature(let featureName): return "Feature:\(featureName)"
            case .default: return "Default"
            }
        }
    }
    
    // MARK: - Log Level
    
    /// 로그의 중요도를 나타내는 레벨입니다.
    enum LogLevel {
        /// 상세한 디버깅 정보
        case debug
        
        /// 유용한 진행 정보
        case info
        
        /// 해결 가능한 오류
        case error
        
        /// 심각한 시스템 장애
        case fault
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info:  return .info
            case .error: return .error
            case .fault: return .fault
            }
        }
        
        fileprivate var icon: String {
            switch self {
            case .debug: return "💬"
            case .info:  return "✅"
            case .error: return "⚠️"
            case .fault: return "❌"
            }
        }
    }
    
    // MARK: - Properties
    private static let subsystem = Bundle.main.bundleIdentifier ?? "BBIP"
    private static var loggers: [String: Logger] = [:]
    
    private static func logger(for category: LogCategory) -> Logger {
        let key = category.rawValue
        if let existing = loggers[key] {
            return existing
        }
        let newLogger = Logger(subsystem: subsystem, category: key)
        loggers[key] = newLogger
        return newLogger
    }
    
    // MARK: - Public API
    
    /// 로그를 출력합니다.
    /// - Parameters:
    ///   - message: 출력할 메시지
    ///   - level: 로그 레벨 (기본: .debug)
    ///   - category: 로그 카테고리 (기본: .default)
    ///   - file: 호출 파일 (자동 채움)
    ///   - function: 호출 함수 (자동 채움)
    ///   - line: 호출 라인 (자동 채움)
    static func log(
        _ message: Any,
        level: LogLevel,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let formattedMessage = "[\(fileName):\(line)] \(function) - \(String(describing: message))"

        #if DEBUG
        // DEBUG 환경: 모든 로그 콘솔에 출력
        print("\(level.icon) \(formattedMessage)")
        #else
        // RELEASE 환경: `fault`만 시스템 로그로 출력
        if level == .fault {
            let logger = logger(for: category)
            logger.log(level: level.osLogType, "\(formattedMessage)")
        }
        #endif
    }
}
