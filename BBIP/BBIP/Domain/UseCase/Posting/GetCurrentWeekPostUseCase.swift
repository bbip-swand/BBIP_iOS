//
//  GetCurrentWeekPostUseCase.swift
//  BBIP
//
//  Created by 이건우 on 9/23/24.
//

import Foundation
import Combine

protocol GetCurrentWeekPostUseCaseProtocol {
    func excute() -> AnyPublisher<RecentPostVO, Error>
}

final class GetCurrentWeekPostUseCase: GetCurrentWeekPostUseCaseProtocol {
    private let repository: PostingRepository
    
    init(repository: PostingRepository) {
        self.repository = repository
    }
    
    func excute() -> AnyPublisher<RecentPostVO, Error> {
        repository.getCurrentWeekPost()
            .eraseToAnyPublisher()
    }
}