//
//  UserInfoSetupContent.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import Foundation

struct UserInfoSetupContent {
    let title: String
    let subTitle: String?
    
    init(
        title: String,
        subTitle: String?
    ) {
        self.title = title
        self.subTitle = subTitle
    }
}

extension UserInfoSetupContent {
    static func generate() -> [UserInfoSetupContent] {
        return [
            UserInfoSetupContent(title: "활동 지역을 알려주세요", subTitle: "스터디를 참여할 지역을 기준으로 선택해주세요"),
            UserInfoSetupContent(title: "관심 분야를 알려주세요", subTitle: "평소 스터디를 가장 많이 하는 분야를 선택해주세요"),
            UserInfoSetupContent(title: "프로필을 꾸며보세요", subTitle: "스터디원들에게 보일 프로필을 만들어주세요"),
            UserInfoSetupContent(title: "태어난 연도를 입력해주세요", subTitle: nil),
            UserInfoSetupContent(title: "현재 직업을 선택해주세요", subTitle: "프로필에서 업데이트 가능합니다")
        ]
    }
}
