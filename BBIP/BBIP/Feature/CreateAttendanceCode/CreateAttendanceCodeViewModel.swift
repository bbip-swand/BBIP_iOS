//
//  CreateAttendanceCodeViewModel.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Foundation
import Combine
import Factory

/// 출석 코드 생성 및 현황 확인, 스터디장 & 스터디홈 용
final class CreateAttendanceCodeViewModel: ObservableObject {
    
    @Published var attendanceCode: String?
    
    @Injected(\.getAttendanceStatusUseCase) private var getAttendanceStatusUseCase
    @Injected(\.createAttendanceCodeUseCase) private var createAttendanceCodeUseCase
    @Injected(\.getAttendanceRecordsUseCase) private var getAttendanceRecordsUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    func createAttendanceCode(
        studyId: String,
        session: Int,
        completion: @escaping () -> Void
    ) {
        createAttendanceCodeUseCase.execute(studyId: studyId, session: session)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.attendanceCode = String(response)
            }
            .store(in: &cancellables)
    }
}
