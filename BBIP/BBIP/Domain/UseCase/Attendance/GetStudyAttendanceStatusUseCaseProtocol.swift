//
//  GetStudyAttendanceStatusUseCaseProtocol.swift
//  BBIP
//
//  Created by 최주원 on 8/25/25.
//

import Combine

protocol GetStudyAttendanceStatusUseCaseProtocol {
    func execute(studyId: String) -> AnyPublisher<AttendanceStatusVO, AttendanceError>
}

final class GetStudyAttendanceStatusUseCase: GetStudyAttendanceStatusUseCaseProtocol {
    private let repository: AttendanceRepository
    
    init(repository: AttendanceRepository) {
        self.repository = repository
    }
    
    /// 현재 진행중인 출결인증이 있는지 여부 확인
    func execute(studyId: String) -> AnyPublisher<AttendanceStatusVO, AttendanceError> {
        repository.getStudyAttendanceStatus(studyId: studyId)
    }
}
