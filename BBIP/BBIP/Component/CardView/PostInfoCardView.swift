//
//  PostInfoCardView.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI

/// 게시글 전체보기에서 사용되는 cardView
struct PostInfoCardView: View {
    @State private var showPostDetailView: Bool = false
    private let vo: PostVO
    
    init(vo: PostVO) {
        self.vo = vo
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CapsuleView(
                title: "\(vo.week)주차",
                type: vo.postType == .notice ? .highlight : .fill
            )
            
            Text(vo.title)
                .font(.bbip(.body1_sb16))
                .foregroundStyle(.gray9)
                .lineLimit(1)
            
            Text(vo.content)
                .font(.bbip(.caption3_r12))
                .foregroundStyle(.gray8)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            HStack(spacing: 9) {
                Text(timeAgo(date: vo.createdAt))
                
                Capsule()
                    .frame(width: 1, height: 8)
                    .foregroundStyle(.gray3)
                
                Text(vo.writer)
            }
            .font(.bbip(.caption3_r12))
            .foregroundStyle(.gray6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
        )
        .onTapGesture {
            showPostDetailView = true
        }
        .padding(.horizontal, 17)
        .navigationDestination(isPresented: $showPostDetailView) {
            PostingDetailView(postId: vo.postId)
        }
        
    }
}
