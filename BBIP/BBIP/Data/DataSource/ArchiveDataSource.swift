//
//  ArchiveDataSource.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class ArchiveDataSource {
    private let provider = MoyaProvider<ArchiveAPI>(plugins: [TokenPlugin(), LoggerPlugin()])

    func getArchivedFile(studyId: String) -> AnyPublisher<[ArchivedFileInfoDTO], Error> {
        return provider.requestPublisher(.getArchivedFile(studyCode: studyId))
            .map(BaseResponseDTO<[ArchivedFileInfoDTO]>.self, using: JSONDecoder.iso8601WithMilliseconds4Decoder())
            .map(\.data)
            .mapError { error in
                print("Error: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
}
