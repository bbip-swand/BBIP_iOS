//
//  PostingDetailView.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import SwiftUI

struct PostingDetailView: View {
    @ObservedObject var viewModel: PostingDetailViewModel = DIContainer.shared.makePostingDetailViewModel()
    private let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        postInfo
                            .padding(.top, 16)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 26)

                        content
                            .padding(.bottom, 30)
                            .padding(.horizontal, 26)
                    }
                    .background(.mainWhite)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundStyle(.gray3)
                    
                    comments
                        .containerRelativeFrame([.horizontal, .vertical], alignment: .top)
                        .background(.gray1)
                    
                }
            }
            .scrollIndicators(.never)
            .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .backButtonStyle()
        .toolbar {
            // edit & removeable
        }
        .onAppear {
            viewModel.getPostDetail(postingId: postId)
        }
    }

    // writer, createdAt...
    private var postInfo: some View {
        Group {
            if let vo = viewModel.postDetailData {
                HStack(alignment: .top, spacing: 12) {
                    LoadableImageView(imageUrl: "", size: 36)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 9) {
                            Text(vo.writer)
                                .font(.bbip(.body1_sb16))
                                .foregroundStyle(.gray8)
                            
                            Text(vo.isManager ? "팀장" : "팀원")
                                .font(.bbip(.caption3_r12))
                                .foregroundStyle(.gray5)
                        }
                        
                        Text(vo.createdAt)
                            .font(.bbip(.caption3_r12))
                            .foregroundStyle(.gray5)
                    }
                    Spacer()
                }
            } else {
                Group {
                    HStack(spacing: 12) {
                        LoadableImageView(imageUrl: "", size: 36)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 9) {
                                Text("Writer")
                                    .font(.bbip(.body1_sb16))
                                    .foregroundStyle(.gray8)
                                
                                Text("ph")
                                    .font(.bbip(.caption3_r12))
                                    .foregroundStyle(.gray5)
                            }
                            Text("Date Placeholder")
                                .font(.bbip(.caption3_r12))
                                .foregroundStyle(.gray5)
                        }
                        
                        Spacer()
                    }
                }
                .redacted(reason: .placeholder)
            }
        }
    }

    private var content: some View {
        Group {
            if let vo = viewModel.postDetailData {
                VStack(alignment: .leading, spacing: 13) {
                    Text(vo.title)
                        .font(.bbip(.title3_sb20))
                    
                    Text(vo.content)
                        .font(.bbip(.body2_m14))
                }
                // TODO: - Images...
            } else {
                Group {
                    VStack(alignment: .leading, spacing: 13) {
                        Text("Title Placeholder")
                            .font(.bbip(.title3_sb20))
                        
                        Text("Content Placeholder...")
                            .font(.bbip(.body2_m14))
                    }
                }
                .redacted(reason: .placeholder)
            }
        }
        .foregroundStyle(.gray8)
    }
    
    private var comments: some View {
        VStack(spacing: 0) {
            if let vo = viewModel.postDetailData {
                ForEach(0..<vo.commnets.count, id: \.self) { index in
                    CommentCell(vo: vo.commnets[index])
                }
            } else {
                ForEach(0..<1, id: \.self) { index in
                    CommentCell(vo: .placeholderMock())
                        .redacted(reason: .placeholder)
                }
            }
        }
    }
}
