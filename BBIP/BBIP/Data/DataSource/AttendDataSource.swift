//
//  AttendDataSource.swift
//  BBIP
//
//  Created by 조예린 on 9/23/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class AttendDataSource{
    private let provider = MoyaProvider<AttendanceAPI>(plugins: [TokenPlugin()])
    
    //MARK: - POST
    func createAttendCode(dto: CreateCodeDTO) -> AnyPublisher<CreateCodeResponseDTO, Error> {
        provider.requestPublisher(.createCode(dto: dto))
            .tryMap{ response in
                guard (200...299).contains(response.statusCode) else{
                    if (400...499).contains(response.statusCode) {
                        // 400번대 에러일 때 ErrorResponseDTO로 파싱
                        if let errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                            // 콘솔에 에러 메시지 출력
                            print("Error: \(errorDTO.message) (Status code: \(errorDTO.statusCode))")
                            throw NSError(
                                domain: "Fail get Attend record",
                                code: errorDTO.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorDTO.message]
                            )
                        } else {
                            // ErrorResponseDTO로 파싱 실패 시
                            throw NSError(
                                domain: "CreateCode Error",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "[CreateCodeDataSource] createAttendCode() failed with status code \(response.statusCode)"]
                            )
                        }
                    }
                    throw NSError(
                        domain: "CreateCode Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[CreateCodeDataSource] createAttendCode() failed with status code \(response.statusCode)"]
                    )
                }
                
                return response.data
            }
            .decode(type: CreateCodeResponseDTO.self, decoder: JSONDecoder())
            .mapError {error in
                return error}
            .eraseToAnyPublisher()
    }
    
    //MARK: -POST
    func enterCode(dto: EnterCodeDTO) -> AnyPublisher<Void,Error>{
        provider.requestPublisher(.enterCode(dto: dto))
            .tryMap{response in
                guard(200...299).contains(response.statusCode) else{
                    if (400...499).contains(response.statusCode) {
                        // 400번대 에러일 때 ErrorResponseDTO로 파싱
                        if let errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                            // 콘솔에 에러 메시지 출력
                            print("Error: \(errorDTO.message) (Status code: \(errorDTO.statusCode))")
                            throw NSError(
                                domain: "Fail get Attend record",
                                code: errorDTO.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorDTO.message]
                            )
                        } else {
                            // ErrorResponseDTO로 파싱 실패 시
                            throw NSError(
                                domain: "EnterCode Error",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey:"[EnterCodeDataSource] enterCode() failed with status code \(response.statusCode)"]
                            )
                        }
                    }
                    throw NSError(
                        domain: "EnterCode Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey:"[EnterCodeDataSource] enterCode() failed with status code \(response.statusCode)"]
                    )
                }
                return ()
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: -GET
    func getStatus() -> AnyPublisher<GetStatusResponseDTO,Error>{
        provider.requestPublisher(.getStatus)
            .tryMap{response in
                guard (200...299).contains(response.statusCode) else {
                    if (400...499).contains(response.statusCode) {
                        // 400번대 에러일 때 ErrorResponseDTO로 파싱
                        if let errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                            // 콘솔에 에러 메시지 출력
                            print("Error: \(errorDTO.message) (Status code: \(errorDTO.statusCode))")
                            throw NSError(
                                domain: "Fail get Attend record",
                                code: errorDTO.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorDTO.message]
                            )
                        } else {
                            // ErrorResponseDTO로 파싱 실패 시
                            throw NSError(
                                domain: "Get Attendance Code Error",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "[GetStatusDataSource] getStatus() failed with status code \(response.statusCode)"]
                            )
                        }
                    }
                    throw NSError(
                        domain: "Get Attendance Code Error",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[GetStatusDataSource] getStatus() failed with status code \(response.statusCode)"]
                    )
                }
                return response.data
            }
            .decode(type: GetStatusResponseDTO.self, decoder:JSONDecoder.iso8601WithMillisecondsDecoder())
            .mapError{ error in
                return error}
            .eraseToAnyPublisher()
    }
    
    //MARK: -GET
    func getAttendRecord(studyId: String) -> AnyPublisher<[GetAttendRecordDTO], Error> {
        provider.requestPublisher(.getAttendRecord(studyId: studyId))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    if (400...499).contains(response.statusCode) {
                        // 400번대 에러일 때 ErrorResponseDTO로 파싱
                        if let errorDTO = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data) {
                            // 콘솔에 에러 메시지 출력
                            print("Error: \(errorDTO.message) (Status code: \(errorDTO.statusCode))")
                            throw NSError(
                                domain: "Fail get Attend record",
                                code: errorDTO.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorDTO.message]
                            )
                        } else {
                            throw NSError(
                                domain: "Fail get Attend record",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "[getAttendRecord] Failed to decode error response"]
                            )
                        }
                    }
                    throw NSError(
                        domain: "Fail get Attend record",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "[getAttendRecord] getAttendRecord() failed with \(response.statusCode)"]
                    )
                }
                // Print response data as a string for debugging
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                } else {
                    print("Failed to convert response data to String")
                }
                return response.data
            }
            .decode(type: [GetAttendRecordDTO].self, decoder: JSONDecoder()) // 여기서 배열 형태로 디코딩
            .mapError { error in return error }
            .eraseToAnyPublisher()
    }
}
