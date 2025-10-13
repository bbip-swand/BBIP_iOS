//
//  CommentCell.swift
//  BBIP
//
//  Created by 이건우 on 10/1/24.
//

import SwiftUI
import UIKit

struct CommentCell: View {
    private let vo: CommentVO
    let onDelete: () -> Void
    
    init(vo: CommentVO, onDelete: @escaping () -> Void) {
        self.vo = vo
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            LoadableImageView(imageUrl: vo.profileImageUrl, size: 36)
                .padding(.vertical, 2)
                .padding(.leading, 8)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(vo.writer)
                    .font(.bbip(.body2_b14))
                
                Text(vo.timeAgo)
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray5)
                
                Text(vo.content)
                    .font(.bbip(.body2_m14))
            }
            .foregroundStyle(.gray8)
            .padding(.vertical, 8)
            
            Spacer()
            
            if vo.isManager {
                Menu {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Text("삭제")
                            .font(.bbip(.body2_m14))
                    }
                } label: {
                    Image("more_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .padding(8)
                }
            }
            
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray2)
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = vo.content
            } label: {
                Label("복사", systemImage: "doc.on.doc")
            }
        }
    }
}
