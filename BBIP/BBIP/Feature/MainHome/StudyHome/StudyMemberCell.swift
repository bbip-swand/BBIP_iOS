//
//  StudyMemberCell.swift
//  BBIP
//
//  Created by 이건우 on 9/29/24.
//

import SwiftUI

struct StudyMemberCell: View {
    
    private let vo: StudyMemberVO
    
    init(vo: StudyMemberVO) {
        self.vo = vo
    }
    
    var memberPositionString: String {
        vo.isManager ? "팀장" : "팀원"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
                .frame(width: 90, height: 100)
            
            VStack(spacing: 0) {
                LoadableImageView(imageUrl: vo.memberImageURL, size: 40)
                
                Text(vo.memberName)
                    .font(.bbip(.body2_m14))
                    .padding(.top, 8)
                    .padding(.bottom, 3)
                
                Text(memberPositionString)
                    .font(.bbip(.caption2_m12))
                    .foregroundStyle(.gray6)
            }
        }
    }
}

struct StudyMemberInviteCell: View {
    private let studyInviteCode: String
    
    init(inviteCode: String) {
        self.studyInviteCode = inviteCode
    }
    
    var body: some View {
        ShareLink(item: URL(string: "http://join.bbip.kr/join-study/\(studyInviteCode)")!) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 90, height: 100)
                    .foregroundStyle(.gray3)
                
                VStack(spacing: 10) {
                    Image("add_plus_big")
                    
                    Text("초대하기")
                        .font(.bbip(.body2_m14))
                        .foregroundStyle(.gray7)
                }
            }
        }
    }
}
