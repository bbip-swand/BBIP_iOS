//
//  ArchiveRepository.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import Foundation
import Combine

protocol ArchiveRepository {
    func getArchivedFile(studyId: String) -> AnyPublisher<[ArchivedFileInfoVO], Error>
}

final class ArchiveRepositoryImpl: ArchiveRepository {
    private let dataSource: ArchiveDataSource
    private let mapper: ArchivedFileInfoMapper

    init(
        dataSource: ArchiveDataSource,
        mapper: ArchivedFileInfoMapper
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    func getArchivedFile(studyId: String) -> AnyPublisher<[ArchivedFileInfoVO], any Error> {
        dataSource.getArchivedFile(studyId: studyId)
            .map { [weak self] dto in
                guard let self = self else { return [] }
                return self.mapper.toVO(dto: dto)
            }
            .eraseToAnyPublisher()
    }
}
