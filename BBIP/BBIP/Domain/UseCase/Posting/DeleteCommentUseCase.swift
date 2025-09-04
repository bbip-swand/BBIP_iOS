//
//  DeleteCommentUseCase.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Combine

protocol DeleteCommentUseCaseProtocol {
    func execute(commentId: Int) -> AnyPublisher<Bool, Error>
}

final class DeleteCommentUseCase: DeleteCommentUseCaseProtocol {
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func execute(commentId: Int) -> AnyPublisher<Bool, Error> {
        repository.deleteComment(commentId: commentId)
            .eraseToAnyPublisher()
    }
}
