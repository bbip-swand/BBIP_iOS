//
//  GridButtonContent.swift
//  BBIP
//
//  Created by 이건우 on 8/27/24.
//

import Foundation

struct GridButtonContent {
    let imgName: String
    let text: String
    
    init(
        imgName: String,
        text: String
    ) {
        self.imgName = imgName
        self.text = text
    }
}

extension GridButtonContent {
    static func generateInterestContent() -> [GridButtonContent] {
        return [
            GridButtonContent(imgName: "category_major", text: "전공과목"),
            GridButtonContent(imgName: "category_self-improvement", text: "자기계발"),
            GridButtonContent(imgName: "category_language", text: "어학(토익 등)"),
            GridButtonContent(imgName: "category_license", text: "자격증"),
            GridButtonContent(imgName: "category_interview", text: "면접"),
            GridButtonContent(imgName: "category_development", text: "개발"),
            GridButtonContent(imgName: "category_design", text: "디자인"),
            GridButtonContent(imgName: "category_hobby", text: "취미"),
            GridButtonContent(imgName: "category_etc", text: "기타")
        ]
    }
    
    static func generateJobContent() -> [GridButtonContent] {
        return [
            GridButtonContent(imgName: "job_academic", text: "대학생"),
            GridButtonContent(imgName: "job_jobSeeker", text: "취준생"),
            GridButtonContent(imgName: "job_worker", text: "직장인"),
            GridButtonContent(imgName: "job_etc", text: "기타")
        ]
    }
}
