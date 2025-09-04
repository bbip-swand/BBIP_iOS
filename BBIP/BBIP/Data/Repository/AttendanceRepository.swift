//
//  AttendanceRepository.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Combine

protocol AttendanceRepository {
    func getAttendanceStatus() -> AnyPublisher<AttendanceStatusVO, AttendanceError>
    func getAttendanceRecords(studyId: String) ->  AnyPublisher<[AttendanceRecordVO], AttendanceError>
    func createAttendanceCode(studyId: String, session: Int) -> AnyPublisher<Int, AttendanceError>
    func submitAttendanceCode(studyId: String, code: Int) -> AnyPublisher<Bool, AttendanceError>
    func getStudyAttendanceStatus(studyId: String) -> AnyPublisher<AttendanceStatusVO, AttendanceError>
}

final class AttendanceRepositoryImpl: AttendanceRepository {
    private let dataSource: AttendanceDataSource
    private let statusMapper: AttendanceStatusMapper
    private let recordMapper: AttendanceRecordMapper
    
    init(
        dataSource: AttendanceDataSource,
        statusMapper: AttendanceStatusMapper,
        recordMapper: AttendanceRecordMapper
    ) {
        self.dataSource = dataSource
        self.statusMapper = statusMapper
        self.recordMapper = recordMapper
    }
    
    func getAttendanceStatus() -> AnyPublisher<AttendanceStatusVO, AttendanceError> {
        dataSource.getAttendanceStatus()
            .map { self.statusMapper.toVO(dto: $0) }
            .eraseToAnyPublisher()
    }
    
    func getAttendanceRecords(studyId: String) -> AnyPublisher<[AttendanceRecordVO], AttendanceError> {
        dataSource.getAttendanceRecords(studyId: studyId)
            .map { self.recordMapper.toVO(dto: $0) }
            .eraseToAnyPublisher()
    }
    
    func createAttendanceCode(studyId: String, session: Int) -> AnyPublisher<Int, AttendanceError> {
        dataSource.createAttendanceCode(studyId: studyId, session: session)
            .eraseToAnyPublisher()
    }
    
    func submitAttendanceCode(studyId: String, code: Int) -> AnyPublisher<Bool, AttendanceError> {
        dataSource.submitAttendanceCode(studyId: studyId, code: code)
            .eraseToAnyPublisher()
    }
    
    func getStudyAttendanceStatus(studyId: String) -> AnyPublisher<AttendanceStatusVO, AttendanceError> {
        dataSource.getStudyAttendanceStatus(studyId: studyId)
            .map { self.statusMapper.toVO(dto: $0) }
            .eraseToAnyPublisher()
    }
}
