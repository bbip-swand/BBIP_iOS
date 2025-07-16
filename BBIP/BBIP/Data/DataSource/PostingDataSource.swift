//
//  PostingDataSource.swift
//  BBIP
//
//  Created by 이건우 on 9/21/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class PostingDataSource {
    private let provider = MoyaProvider<PostingAPI>(plugins: [TokenPlugin(), LoggerPlugin()])

    func getCurrentWeekPosting() -> AnyPublisher<[PostDTO], Error> {
        return provider.requestPublisher(.getCurrentWeekPosting)
            .map(BaseResponseDTO<[PostDTO]>.self, using: JSONDecoder.yyyyMMddDecoder())
            .map(\.data)
            //.decode(type: [PostDTO].self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getStudyPosting(studyId: String) -> AnyPublisher<[PostDTO], Error> {
        return provider.requestPublisher(.getStudyPosting(studyId: studyId))
            .map(BaseResponseDTO<[PostDTO]>.self, using: JSONDecoder.yyyyMMddDecoder())
            .map(\.data)
            //.decode(type: [PostDTO].self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                print("Error: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getPostingDetails(postingId: Int) -> AnyPublisher<PostDetailDTO, Error> {
        return provider.requestPublisher(.getPostingDetail(postingId: postingId))
            .map(BaseResponseDTO<PostDetailDTO>.self, using: JSONDecoder.yyyyMMddDecoder())
            .map(\.data)
            //.decode(type: PostDetailDTO.self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func createCommnet(postingId: Int, content: String) -> AnyPublisher<Bool, Error> {
        return provider.requestPublisher(.createComment(postingId: postingId, content: content))
            .map { response in
                return (200...299).contains(response.statusCode)
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func createPosting(dto: CreatePostingDTO) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.createPosting(dto: dto))
            .map { response in
                return (200...299).contains(response.statusCode)
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func deletePost(postId: Int) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.deletePost(postId: postId))
            .tryMap { response in
                print(response.statusCode)
                if (200...299).contains(response.statusCode) {
                    return true
                } else if response.statusCode == 400 {
                    return false // already study member
                } else {
                    throw NSError(
                        domain: "deletePost Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[PostingDataSource] deletePost() failed with status code \(response.statusCode)"]
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    func deleteComment(commentId: Int) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.deleteComment(commentId: commentId))
            .tryMap { response in
                print(response.statusCode)
                if (200...299).contains(response.statusCode) {
                    return true
                } else if response.statusCode == 400 {
                    return false // already study member
                } else {
                    throw NSError(
                        domain: "deleteComment Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[PostingDataSource] deleteComment() failed with status code \(response.statusCode)"]
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
