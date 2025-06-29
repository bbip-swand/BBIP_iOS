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
    
    private let getPostDetailUseCase: GetPostDetailUseCaseProtocol
    private let createCommentUseCase: CreateCommentUseCaseProtocol
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
        createCommentUseCase: CreateCommentUseCaseProtocol
    ) {
        self.getPostDetailUseCase = getPostDetailUseCase
        self.createCommentUseCase = createCommentUseCase
    }
    
    private func validateCommentText() {
        isCommentButtonEnabled = !commentText.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func getPostDetail(postingId: String) {
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
    
    func createComment(postingId: String, commentContent: String) {
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
}
