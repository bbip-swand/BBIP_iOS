//
//  PostingDetailView.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import SwiftUI

struct PostingDetailView: View {
    @ObservedObject var viewModel: PostingDetailViewModel = DIContainer.shared.makePostingDetailViewModel()
    @FocusState private var isFocused: Bool
    @State var deleteAlertIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
    private let postId: Int
    
    init(postId: Int) {
        self.postId = postId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                postInfo
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 26)
                
                content
                    .padding(.bottom, 30)
                    .padding(.horizontal, 26)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .foregroundStyle(.gray3)
                
                comments
                
                Spacer()
                    .frame(height: 150)
            }
            .keyboardHideable()
        }
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .mainWhite)
            viewModel.getPostDetail(postingId: postId)
            // 뷰 닫기 클로저 주입
            viewModel.onPostDeleteSuccess = {
                self.dismiss()
            }
        }
        .overlay(alignment: .bottom) {
            commentTextfieldArea
                .bbipShadow1()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .scrollIndicators(.never)
        .backButtonStyle()
        .toolbar{
            if viewModel.postManger {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            deleteAlertIsPresented = true
                        } label: {
                            Text("삭제")
                                .font(.bbip(.body2_m14))
                        }
                    } label: {
                        Image("more_black")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .customAlert(
            isPresented: $deleteAlertIsPresented,
            message: "삭제된 게시글은 복구가 불가능합니다.\n게시글을 삭제 하시겠습니까?") {
                viewModel.deletePost()
            }
    }

    // writer, createdAt...
    private var postInfo: some View {
        Group {
            if let vo = viewModel.postDetailData {
                HStack(alignment: .top, spacing: 12) {
                    LoadableImageView(imageUrl: vo.profileImageUrl, size: 36)
                    
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
                        .frame(minHeight: 44, alignment: .topLeading)
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
                    let comment = vo.commnets[index]
                    CommentCell(vo: comment) {
                        viewModel.deleteComment(commentId: comment.commentId)
                    }
                }
            } else {
                ForEach(0..<1, id: \.self) { index in
                    CommentCell(vo: .placeholderMock()) { }
                        .redacted(reason: .placeholder)
                }
            }
        }
    }
    
    private var commentTextfieldArea: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.mainWhite)
                .frame(height: isFocused ? 80 : 114)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                .overlay(
                    RoundedCorner(radius: 12, corners: [.topLeft, .topRight])
                        .stroke(.gray2, lineWidth: 1)
                )
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 40)
                    .foregroundStyle(.gray2)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 10) {
                    TextField("댓글을 입력하세요", text: $viewModel.commentText)
                        .font(.bbip(.body1_m16))
                        .foregroundStyle(.mainBlack)
                        .focused($isFocused)
                    
                    if viewModel.isCommentButtonEnabled {
                        Button {
                            viewModel.createComment(postingId: postId, commentContent: viewModel.commentText)
                        } label: {
                            Image("comment_send")
                        }
                        .animation(.easeInOut, value: viewModel.isCommentButtonEnabled)
                    }
                    
                }
                .padding(.horizontal, 35)
            }
            .padding(.top, 20)
        }
        .animation(.easeInOut, value: isFocused)
    }
}
