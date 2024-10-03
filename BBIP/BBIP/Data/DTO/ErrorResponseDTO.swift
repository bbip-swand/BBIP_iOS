//
//  ErrorResponseDTO.swift
//  BBIP
//
//  Created by 조예린 on 9/27/24.
//

import Foundation

struct ErrorResponseDTO: Decodable{
    let statusCode: Int
    let message: String
}
