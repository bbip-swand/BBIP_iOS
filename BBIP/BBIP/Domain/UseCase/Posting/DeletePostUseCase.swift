//
//  DeletePostUseCase.swift
//  BBIP
//
//  Created by 최주원 on 7/16/25.
//

import Combine

protocol DeletePostUseCaseProtocol {
    func execute(postId: Int) -> AnyPublisher<Bool, Error>
}

final class DeletePostUseCase: DeletePostUseCaseProtocol {
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func execute(postId: Int) -> AnyPublisher<Bool, Error> {
        repository.deletePost(postId: postId)
            .eraseToAnyPublisher()
    }
}
