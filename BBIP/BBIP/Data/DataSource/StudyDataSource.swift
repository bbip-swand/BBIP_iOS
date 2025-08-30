//
//  StudyDataSource.swift
//  BBIP
//
//  Created by 이건우 on 9/20/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class StudyDataSource {
    private let provider = MoyaProvider<StudyAPI>(plugins: [TokenPlugin(), LoggerPlugin()])
    
    // MARK: - GET
    func getCurrentWeekStudyInfo() -> AnyPublisher<[StudyInfoDTO], any Error> {
        provider.requestPublisher(.getThisWeekStudy)
            .map(BaseResponseDTO<[StudyInfoDTO]>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    /// 진행 중인 스터디 정보 조회
    func getOngoingStudyInfo() -> AnyPublisher<[StudyInfoDTO], any Error> {
        provider.requestPublisher(.getOngoingStudy)
            .map(BaseResponseDTO<[StudyInfoDTO]>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    /// 진행 완료된 스터디 정보 조회
    func getFinishedStudyInfo() ->  AnyPublisher<[StudyInfoDTO], any Error> {
        provider.requestPublisher(.getFinishedStudy)
            .map(BaseResponseDTO<[StudyInfoDTO]>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    /// 스터디 단건 조회 (StudyHome)
    func getFullStudyInfo(studyId: String) -> AnyPublisher<FullStudyInfoDTO, Error> {
        provider.requestPublisher(.getFullStudyInfo(studyId: studyId))
            .map(BaseResponseDTO<FullStudyInfoDTO>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - GET pendingstudy
    func getPendingStudy() -> AnyPublisher<PendingStudyDTO, Error>{
        provider.requestPublisher(.getPendingStudy)
            .map(BaseResponseDTO<PendingStudyDTO>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
        
    
    // MARK: - POST
    /// 스터디 생성
    func createStudy(dto: CreateStudyInfoDTO) -> AnyPublisher<CreateStudyResponseDTO, Error> {
        provider.requestPublisher(.createStudy(dto: dto))
            .map(BaseResponseDTO<CreateStudyResponseDTO>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func joinStudy(studyId: String) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.joinStudy(studyId: studyId))
            .tryMap { response in
                print(response.statusCode)
                if (200...299).contains(response.statusCode) {
                    return true
                } else if response.statusCode == 400 {
                    return false // already study member
                } else {
                    throw NSError(
                        domain: "joinStudy Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[StudyDataSource] createStudy() failed with status code \(response.statusCode)"]
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    func editStudyLocation(
        studyId: String,
        session: Int,
        location: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        provider.request(.editStudyLocation(studyId: studyId, session: session, location: location)) { result in
            switch result {
            case .success(let response):
                let isSuccess = (200...299).contains(response.statusCode)
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteStudy(studyId: String, completion: @escaping (Result<Bool, Error>) -> Void ){
        provider.request(.deleteStudy(studyId: studyId)) { result in
            switch result {
            case .success(let response):
                let isSuccess = (200...299).contains(response.statusCode)
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editStudy(studyId: String, dto: CreateStudyInfoDTO) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.editStudyInfo(studyId: studyId, dto: dto))
            .tryMap { response in
                if (200...299).contains(response.statusCode) {
                return true
            } else if response.statusCode == 400 {
                return false // already study member
            } else {
                    throw NSError(
                        domain: "EditStudy Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[StudyDataSource] editStudy() failed with status code \(response.statusCode)"]
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
