//
//  NoticeBannerView.swift
//  BBIP
//
//  Created by 이건우 on 9/10/24.
//

import SwiftUI

struct NoticeBannerView: View {
    @State private var showPostDetail: Bool = false
    private let postVO: PostVO?
    private let isDark: Bool
    
    init(
        postVO: PostVO?,
        isDark: Bool = false
    ) {
        self.postVO = postVO
        self.isDark = isDark
    }
    
    var body: some View {
        Button {
            if postVO != nil { showPostDetail = true }
        } label: {
            HStack(spacing: 0) {
                Text("공지")
                    .foregroundStyle(.primary3)
                    .font(.bbip(.body1_sb16))
                    .padding(.trailing, 5)
                    .padding(.vertical, 2)
                    .overlay(
                        Circle()
                        .fill(.primary3)
                        .frame(width: 4, height: 4),
                        alignment: .topTrailing
                    )
                    .padding(.trailing, 19)
                
                if let title = postVO?.title {
                    Text(title)
                        .font(.bbip(.body2_m14))
                        .foregroundStyle(isDark ? .gray2 : .gray8)
                        .frame(maxWidth: 284, maxHeight: 20, alignment: .leading)
                } else {
                    Text("등록된 공지가 없어요")
                        .font(.bbip(.body2_m14))
                        .foregroundStyle(.gray6)
                        .frame(maxWidth: 284, maxHeight: 20, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(.leading, 11)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(isDark ? .gray8 : .gray2)
                    .frame(height: 40)
            )
        }
        .padding(.horizontal, 16)
        .navigationDestination(isPresented: $showPostDetail) {
            PostingDetailView(postId: postVO?.postId ?? 0)
        }
        .disabled(postVO == nil)
    }
}
