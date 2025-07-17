//
//  PostingDetailViewModel.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation
import Combine

final class PostingDetailViewModel: ObservableObject {
    @Published var postDetailData: PostDetailVO?
    @Published var commentText: String = "" {
        didSet {
            validateCommentText()
        }
    }
    @Published var isCommentButtonEnabled: Bool = false
    // 삭제 성공 시 호출 클로저
    var onPostDeleteSuccess: (() -> Void)?
    
    // MARK: - UseCase
    private let getPostDetailUseCase: GetPostDetailUseCaseProtocol
    private let deletePostUseCase: DeletePostUseCaseProtocol
    private let createCommentUseCase: CreateCommentUseCaseProtocol
    private let deleteCommentUseCase: DeleteCommentUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // 작성자 매니저 여부 반환용
    var postManger : Bool {
        if let postDetailData = postDetailData {
            return postDetailData.isManager
        } else {
            return false
        }
    }
    
    init(
        getPostDetailUseCase: GetPostDetailUseCaseProtocol,
        deletePostUseCase: DeletePostUseCaseProtocol,
        createCommentUseCase: CreateCommentUseCaseProtocol,
        deleteCommentUseCase: DeleteCommentUseCaseProtocol
    ) {
        self.getPostDetailUseCase = getPostDetailUseCase
        self.deletePostUseCase = deletePostUseCase
        self.createCommentUseCase = createCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
    }
    
    private func validateCommentText() {
        isCommentButtonEnabled = !commentText.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func getPostDetail(postingId: Int) {
        getPostDetailUseCase.execute(postingId: postingId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("load failed PostDetail: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.postDetailData = response
            }
            .store(in: &cancellables)
    }
    
    func createComment(postingId: Int, commentContent: String) {
        createCommentUseCase.execute(postingId: postingId, content: commentContent)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("failed createComment: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.getPostDetail(postingId: postingId)
                self.commentText = ""
            }
            .store(in: &cancellables)
    }
    
    // 게시글 삭제
    func deletePost() {
        guard let postId = postDetailData?.postId else { return }
        deletePostUseCase.execute(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] isSuccess in
                if isSuccess {
                    // 게시글 나가기 함수 추가
                    onPostDeleteSuccess?()
                    print("게시글 삭제 성공")
                } else {
                    print("게시글 삭제 실패")
                }
            }
            .store(in: &cancellables)
    }
    
    // 댓글 삭제
    func deleteComment(commentId: Int) {
        guard let postId = postDetailData?.postId else { return }
        deleteCommentUseCase.execute(commentId: commentId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [self] isSuccess in
                if isSuccess {
                    print("댓글 삭제 성공")
                    // 데이터 갱신
                    getPostDetail(postingId: postId)
                } else {
                    print("댓글 삭제 실패")
                }
            }
            .store(in: &cancellables)
    }
}
