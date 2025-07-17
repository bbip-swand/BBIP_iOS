//
//  PostingRepository.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation
import Combine

protocol PostingRepository {
    func getCurrentWeekPost() -> AnyPublisher<RecentPostVO, Error>
    func getStudyPosting(studyId: String) -> AnyPublisher<RecentPostVO, Error>
    func getPostingDetail(postingId: Int) -> AnyPublisher<PostDetailVO, Error>
    func createComment(postingId: Int, content: String) -> AnyPublisher<Bool, Error>
    func createPosting(dto: CreatePostingDTO) -> AnyPublisher<Bool, Error>
    func deletePost(postId: Int) -> AnyPublisher<Bool, Error>
    func deleteComment(commentId: Int) -> AnyPublisher<Bool, Error>
}

final class PostingRepositoryImpl: PostingRepository {
    private let dataSource: PostingDataSource
    private let recentPostMapper: RecentPostMapper
    private let postDetailMapper: PostDetailMapper

    init(
        dataSource: PostingDataSource,
        recentPostMapper: RecentPostMapper,
        postDetailMapper: PostDetailMapper
    ) {
        self.dataSource = dataSource
        self.recentPostMapper = recentPostMapper
        self.postDetailMapper = postDetailMapper
    }
    
    func getCurrentWeekPost() -> AnyPublisher<RecentPostVO, Error> {
        return dataSource.getCurrentWeekPosting()
            .map { [weak self] dto in
                guard let self = self else { return [] }
                return self.recentPostMapper.toVO(dto: dto)
            }
            .eraseToAnyPublisher()
    }
    
    func getStudyPosting(studyId: String) -> AnyPublisher<RecentPostVO, Error> {
        return dataSource.getStudyPosting(studyId: studyId)
            .map { [weak self] dto in
                guard let self = self else { return [] }
                return self.recentPostMapper.toVO(dto: dto)
            }
            .eraseToAnyPublisher()
    }
    
    func getPostingDetail(postingId: Int) -> AnyPublisher<PostDetailVO, Error> {
        return dataSource.getPostingDetails(postingId: postingId)
            .map { self.postDetailMapper.toVO(dto: $0) }
            .eraseToAnyPublisher()
    }
    
    func createComment(postingId: Int, content: String) -> AnyPublisher<Bool, Error> {
        return dataSource.createCommnet(postingId: postingId, content: content)
            .eraseToAnyPublisher()
    }
    
    func createPosting(dto: CreatePostingDTO) -> AnyPublisher<Bool, Error> {
        return dataSource.createPosting(dto: dto)
            .eraseToAnyPublisher()
    }
    
    func deletePost(postId: Int) -> AnyPublisher<Bool, any Error> {
        return dataSource.deletePost(postId: postId)
            .eraseToAnyPublisher()
    }
    
    func deleteComment(commentId: Int) -> AnyPublisher<Bool, any Error> {
        return dataSource.deleteComment(commentId: commentId)
            .eraseToAnyPublisher()
    }
}
