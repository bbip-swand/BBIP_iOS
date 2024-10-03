//
//  AttendanceCertificationViewModel.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import Foundation
import Combine

final class AttendanceCertificationViewModel: ObservableObject {
    //MARK: - get attend record
    @Published var records: [getAttendRecordVO] = []
     var cancellables = Set<AnyCancellable>()

    //MARK: - apply code
    @Published var remainingTime:Int = 600
    @Published var getStatusData: GetStatusVO?
    
    // MARK: - Code
    @Published var codeDigits: [String] = ["", "", "", ""]
    @Published var showInvalidCodeWarning = false
    @Published var showAttendanceDone = false
    @Published var stringCode: String = ""
    @Published var combinedCode:Int = 0
    //TODO: -studyID식별
    @Published var studyId:String = ""
    @Published var session: Int = 0
    @Published var attendVO : AttendVO?
    
    
    //UseCase
    private let getAttendRecordUseCase: GetAttendRecordUseCaseProtocol
    private let getStatusUseCase: GetStatusUseCaseProtocol
    private let enterCodeUseCase: EnterCodeUseCaseProtocol
    
    init(
        getAttendRecordUseCase: GetAttendRecordUseCaseProtocol,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        getStatusUseCase: GetStatusUseCaseProtocol,
        enterCodeUseCse: EnterCodeUseCaseProtocol
    ){
        self.cancellables = cancellables
        self.getAttendRecordUseCase = getAttendRecordUseCase
        self.getStatusUseCase = getStatusUseCase
        self.enterCodeUseCase = enterCodeUseCse
    }
    
    //MARK: -getAttendRecord
    func getAttendRecord(studyId: String){
        getAttendRecordUseCase.execute(studyId: studyId)
            .receive(on: DispatchQueue.main)
            .sink{completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load attendance records: \(error.localizedDescription)")
                }
            }receiveValue: { [weak self] records in
                guard let self = self else { return }
                self.records = records // 받은 상태 정보를 저장
                print("getAttendRecord: \(records)")
            }
            .store(in: &cancellables)
        
        
    }
    //MARK: -GET status
    func getStatusAttend() {
        getStatusUseCase.execute()
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드에서 받음
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load attend status: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.getStatusData = response
                // remainingTime 계산
                let currentTime = Date()
                let expirationTime = response.startTime.addingTimeInterval(TimeInterval(response.ttl))
                self.remainingTime = max(0, Int(expirationTime.timeIntervalSince(currentTime)) - 9*60*60)
                self.studyId = getStatusData?.studyId ?? ""
                self.session = getStatusData?.session ?? 0
                print("currentTime: \(currentTime)")
                print("expirationTime: \(expirationTime)")
                print("Response ttl : \(response.ttl)")
                print("RemainingTime: \(self.remainingTime)")
                print("GETstatusData: \(getStatusData)")
            }
            .store(in: &cancellables)
    }
    
    //MARK: - PUT attend/apply
    func enterCode(vo: AttendVO) {
        enterCodeUseCase.execute(attendVO: vo)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showAttendanceDone = true
                    self.showInvalidCodeWarning = false
                    break
                case .failure(let error):
                    self.showAttendanceDone = false
                    self.showInvalidCodeWarning = true
                    print("Failed to enter the code: \(error.localizedDescription)")
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
    
    
    func handleTextFieldChange(index: Int, newValue: String) -> Int? {
        if newValue.isEmpty {
            return moveToPreviousField(index: index)
        } else {
            codeDigits[index] = String(newValue.prefix(1))
            updateCombinedCode()
            resetWarning()
            if isComplete() {
                
            }
            return moveToNextField(index: index)
        }
    }
    
    
    func moveToNextField(index: Int) -> Int? {
        return (index < 3) ? index + 1 : nil
    }
    
    
    func moveToPreviousField(index: Int) -> Int? {
        return (index > 0) ? index - 1 : 0
    }
    
    func isComplete() -> Bool {
        return codeDigits.allSatisfy { $0.count == 1 }
    }
    
    func updateCombinedCode() {
        stringCode = codeDigits.joined()
        combinedCode = Int(stringCode) ?? 0
        print(combinedCode)
    }
    
    func resetWarning() {
        if codeDigits.contains(where: { $0.isEmpty }) {
            showInvalidCodeWarning = false
        }
    }
    
}
