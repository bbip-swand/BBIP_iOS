//
//  UserInfoVO.swift
//  BBIP
//
//  Created by 이건우 on 9/7/24.
//

import Foundation

struct UserInfoVO {
    let selectedArea: [String?]
    let selectedInterestIndex: [Int]
    let userName: String
    let profileImageUrl: String
    let birthYear: String
    let selectedJobIndex: [Int]
}

struct ProfileDTO : Decodable {
    let location: [String?]
    let interest: [Int]
    let name: String
    let profileImageUrl: String?
    let birthYear: Int
    let occupation: Int
}


