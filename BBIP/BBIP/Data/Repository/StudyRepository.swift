//
//  StudyRepository.swift
//  BBIP
//
//  Created by 이건우 on 9/20/24.
//

import Foundation
import Combine

protocol StudyRepository {
    func getIsTodayStudy(studyId: String) -> AnyPublisher<Bool, Error>
    func getCurrentWeekStudyInfo() -> AnyPublisher<[CurrentWeekStudyInfoVO], Error>
    func getOngoingStudyInfo() -> AnyPublisher<[StudyInfoVO], Error>
    func getFullStudyInfo(studyId: String) -> AnyPublisher<FullStudyInfoVO, Error>
    func createStudy(vo: CreateStudyInfoVO) -> AnyPublisher<CreateStudyResponseDTO, Error>
    func joinStudy(studyId: String) -> AnyPublisher<Bool, Error>
    func getFinishedStudyInfo() -> AnyPublisher<[StudyInfoVO], Error>
    func getPendingStudy() -> AnyPublisher<PendingStudyVO, Error>
    func editStudy(studyId: String, vo: ModifyStudyInfoVO) -> AnyPublisher<Bool, Error>
}

final class StudyRepositoryImpl: StudyRepository {
    private let dataSource: StudyDataSource
    private let studyInfoMapper: StudyInfoMapper
    private let createStudyInfoMapper: CreateStudyInfoMapper
    private let currentWeekStudyInfoMapper: CurrentWeekStudyInfoMapper
    private let fullStudyInfoMapper: FullStudyInfoMapper
    private let pendingStudyMapper: PendingStudyMapper

    init(
        dataSource: StudyDataSource,
        studyInfoMapper: StudyInfoMapper,
        createStudyInfoMapper: CreateStudyInfoMapper,
        currentWeekStudyInfoMapper: CurrentWeekStudyInfoMapper,
        fullStudyInfoMapper: FullStudyInfoMapper,
        pendingStudyMapper : PendingStudyMapper
    ) {
        self.dataSource = dataSource
        self.studyInfoMapper = studyInfoMapper
        self.createStudyInfoMapper = createStudyInfoMapper
        self.currentWeekStudyInfoMapper = currentWeekStudyInfoMapper
        self.fullStudyInfoMapper = fullStudyInfoMapper
        self.pendingStudyMapper = pendingStudyMapper
    }
    
    func getIsTodayStudy(studyId: String) -> AnyPublisher<Bool, Error> {
        dataSource.getIsTodayStudy(studyId: studyId)
            .eraseToAnyPublisher()
    }
    
    func getCurrentWeekStudyInfo() -> AnyPublisher<[CurrentWeekStudyInfoVO], Error> {
        dataSource.getCurrentWeekStudyInfo()
            .map { [weak self] dtoArray in
                guard let self = self else { return [] }
                return dtoArray.map { self.currentWeekStudyInfoMapper.toVO(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func getOngoingStudyInfo() -> AnyPublisher<[StudyInfoVO], Error> {
        dataSource.getOngoingStudyInfo()
            .map { [weak self] dtoArray in
                guard let self = self else { return [] }
                return dtoArray.map { self.studyInfoMapper.toVO(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func getFullStudyInfo(studyId: String) -> AnyPublisher<FullStudyInfoVO, Error> {
        dataSource.getFullStudyInfo(studyId: studyId)
            .map { self.fullStudyInfoMapper.toVO(dto: $0) }
            .eraseToAnyPublisher()
    }
    
    func getFinishedStudyInfo() -> AnyPublisher<[StudyInfoVO], any Error> {
        dataSource.getFinishedStudyInfo()
            .map { [weak self] dtoArray in
                guard let self = self else { return [] }
                return dtoArray.map { self.studyInfoMapper.toVO(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func createStudy(vo: CreateStudyInfoVO) -> AnyPublisher<CreateStudyResponseDTO, Error> {
        let dto = createStudyInfoMapper.toDTO(vo: vo)
        print("createStudy dto: \(dto)")
        return dataSource.createStudy(dto: dto)
            .eraseToAnyPublisher()
    }
    
    func joinStudy(studyId: String) -> AnyPublisher<Bool, Error> {
        dataSource.joinStudy(studyId: studyId)
            .eraseToAnyPublisher()
    }
    
    func getPendingStudy() -> AnyPublisher<PendingStudyVO, any Error> {
        dataSource.getPendingStudy()
            .map { return self.pendingStudyMapper.toVO(dto: $0)}
            .eraseToAnyPublisher()
    }
    
    func editStudy(studyId: String, vo: ModifyStudyInfoVO) -> AnyPublisher<Bool, Error> {
        let dto = createStudyInfoMapper.toDTO(vo: vo)
        return dataSource.editStudy(studyId: studyId, dto: dto)
            .eraseToAnyPublisher()
    }
}

