//
//  GetAttendRecordUseCase.swift
//  BBIP
//
//  Created by 조예린 on 9/28/24.
//

import Foundation
import Combine

protocol GetAttendRecordUseCaseProtocol{
    func execute(studyId: String) -> AnyPublisher<[getAttendRecordVO], Error>
}

final class GetAttendRecordUseCase: GetAttendRecordUseCaseProtocol{
    private let repository : AttendRepository
    
    init (repository: AttendRepository){
        self.repository = repository
    }
    
    func execute(studyId: String) -> AnyPublisher<[getAttendRecordVO], any Error> {
        return repository.getAttendRecord(studyId: studyId)
            .eraseToAnyPublisher()
    }
}
