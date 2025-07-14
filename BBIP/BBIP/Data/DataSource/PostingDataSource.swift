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
            .map(\.data)
            .decode(type: [PostDTO].self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getStudyPosting(studyId: String) -> AnyPublisher<[PostDTO], Error> {
        return provider.requestPublisher(.getStudyPosting(studyId: studyId))
            .map(\.data)
            .decode(type: [PostDTO].self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                print("Error: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func getPostingDetails(postingId: String) -> AnyPublisher<PostDTO, Error> {
        return provider.requestPublisher(.getPostingDetail(postingId: postingId))
            .map(\.data)
            .decode(type: PostDTO.self, decoder: JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func createCommnet(postingId: String, content: String) -> AnyPublisher<Bool, Error> {
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
}
