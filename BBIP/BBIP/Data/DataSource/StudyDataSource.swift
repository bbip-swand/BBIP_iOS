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
    private let provider = MoyaProvider<StudyAPI>(plugins: [TokenPlugin()])
    
    // MARK: - GET
    /// 금주 스터디 조회 (UserHome)
    func getCurrentWeekStudyInfo() -> AnyPublisher<[CurrentWeekStudyInfoDTO], Error> {
        provider.requestPublisher(.getThisWeekStudy)
            .map(\.data)
            .decode(type: [CurrentWeekStudyInfoDTO].self, decoder: JSONDecoder.yyyyMMddDecoder())
            .eraseToAnyPublisher()
    }
    
    /// 진행 중인 스터디 정보 조회
    func getOngoingStudyInfo() -> AnyPublisher<[StudyInfoDTO], Error> {
        provider.requestPublisher(.getOngoingStudy)
            .map(\.data)
            .decode(type: [StudyInfoDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    //끝난 거 정보
    func getFinishedStudyInfo() -> AnyPublisher<[StudyInfoDTO], Error>{
        provider.requestPublisher(.getFinishedStudy)
            .map(\.data)
            .decode(type: [StudyInfoDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// 스터디 단건 조회 (StudyHome)
    func getFullStudyInfo(studyId: String) -> AnyPublisher<FullStudyInfoDTO, Error> {
        provider.requestPublisher(.getFullStudyInfo(studyId: studyId))
            .map(\.data)
            .decode(type: FullStudyInfoDTO.self, decoder: JSONDecoder())
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
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    throw NSError(
                        domain: "CreateStudy Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[StudyDataSource] createStudy() failed with status code \(response.statusCode)"]
                    )
                }
                return response.data
            }
            .decode(type: CreateStudyResponseDTO.self, decoder: JSONDecoder())
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func joinStudy(studyId: String) -> AnyPublisher<Bool, Error> {
        provider.requestPublisher(.joinStudy(studyId: studyId))
            .tryMap { response in
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
            print(studyId)
            switch result {
            case .success(let response):
                let isSuccess = (200...299).contains(response.statusCode)
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
