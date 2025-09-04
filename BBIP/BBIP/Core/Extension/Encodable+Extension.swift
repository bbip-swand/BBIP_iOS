//
//  Encodable+Extension.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Foundation

extension Encodable {
    /// Encodable → Dictionary 변환 확장
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        return jsonObject as? [String: Any] ?? [:]
    }
}
