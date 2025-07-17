//
//  JSONDecoder+Extension.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import Foundation

extension JSONDecoder {
    /// "yyyy-MM-dd" 형식의 DateDecoder
    static func yyyyMMddDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        return decoder
    }
    
    /// ISO8601 밀리초까지 포함하는 DateDecoder
    static func iso8601WithMillisecondsDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithMilliseconds)
        return decoder
    }
    
    /// ISO8601 초까지 포함하는 DateDecoder
    static func iso8601WithsecondDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithSecond)
        return decoder
    }
    
    
    static func isCreatedAtDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.createdAt)
        return decoder
    }
}
