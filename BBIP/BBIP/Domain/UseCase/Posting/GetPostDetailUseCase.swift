//
//  GetPostDetailUseCase.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation
import Combine

protocol GetPostDetailUseCaseProtocol {
    func execute(postingId: Int) -> AnyPublisher<PostDetailVO, Error>
}

final class GetPostDetailUseCase: GetPostDetailUseCaseProtocol {
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func execute(postingId: Int) -> AnyPublisher<PostDetailVO, Error> {
        repository.getPostingDetail(postingId: postingId)
            .eraseToAnyPublisher()
    }
}


