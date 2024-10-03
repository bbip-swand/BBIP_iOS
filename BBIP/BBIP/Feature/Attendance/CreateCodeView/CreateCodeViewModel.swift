//
//  CreateCodeViewModel.swift
//  BBIP
//
//  Created by 조예린 on 9/28/24.
//

import Foundation
import Combine
import CombineMoya

//TODO: studyHome에서 createcodeviewmodel로 studyid옮기기
class CreateCodeViewModel: ObservableObject{
    
    @Published var postCode: Int = 1234 // 코드보낼때
    @Published var getCode: String = ""
    private var createCodeUseCase: CreateCodeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(createCodeUseCase: CreateCodeUseCaseProtocol) {
        self.createCodeUseCase = createCodeUseCase
    }
    
    func createCode(attendVO: AttendVO) {
        createCodeUseCase.execute(attendVO: attendVO)
            .map { $0.code } // CreateCodeResponseDTO에서 code만 추출
            .sink{ completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("Error occurred: \(error.localizedDescription)")
                }
            }receiveValue: { [weak self] code in
                self!.getCode = String(code)
                print("Received code: \(code)")
                print("Received getCode: \(self!.getCode)")
            }
            .store(in: &cancellables)
    }
}
