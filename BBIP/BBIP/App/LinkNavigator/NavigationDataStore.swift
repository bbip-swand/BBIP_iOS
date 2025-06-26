//
//  NavigationDataStore.swift
//  BBIP
//
//  Created by 최주원 on 6/26/25.
//

import Foundation

/// Navigation VIew 전달용 데이터 임시 저장
/// 1. navigator -> push 작업 전 store을 통해 저장
/// 2. push할 때 items -> 각 변수 key값 전달
/// 3. Builder에서 key을 통해 데이터 반환
/// 4. 해당 데이터 view 전달
final class NavigationDataStore {
    static let shared = NavigationDataStore()
    
    private var store: [String: Any] = [:]
    
    private init() { }
    
    /// 데이터 저장
    /// data: T -> 전달할 데이터
    /// - return
    /// key: String -> 임시 저장 키
    func store<T>(_ data: T) -> String {
        let key = UUID().uuidString
        store[key] = data
        return key
    }
    
    /// 키값을 통해 데이터 불러오기
    /// key: String -> store에서 반환한 key 값 입력
    /// - return
    /// 해당 형태로 반환
    func retrieve<T>(forKey key: String) -> T? {
        // 데이터 반환 후 삭제
        defer {
            store.removeValue(forKey: key)
        }
        
        // 저장된 데이터를 원하는 타입(T)으로 캐스팅하여 반환
        return store[key] as? T
    }
}
