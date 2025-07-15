//
//  AttendanceDataSource.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class AttendanceDataSource {
    private let provider = MoyaProvider<AttendanceAPI>(plugins: [TokenPlugin(), LoggerPlugin()])
    
    /// 현재 출결 인증 존재 여부를 확인
    func getAttendanceStatus() -> AnyPublisher<AttendanceStatusDTO, AttendanceError> {
        provider.requestPublisher(.getStatus)
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    if response.statusCode == 404 {
                        throw AttendanceError.attendanceNotFound
                    } else {
                        throw AttendanceError.unknownError(statusCode: response.statusCode)
                    }
                }
                return response.data
            }
            .decode(type: AttendanceStatusDTO.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? AttendanceError ?? .decodingError
            }
            .eraseToAnyPublisher()
    }
    
    /// 출결 현황 조회, 스터디 홈에서 출석 현황을 조회할 때 사용
    func getAttendanceRecords(studyId: String) ->  AnyPublisher<[AttendanceRecordDTO], AttendanceError> {
        provider.requestPublisher(.getAttendRecord(studyId: studyId))
            .map(\.data)
            .decode(type: [AttendanceRecordDTO].self, decoder: JSONDecoder())
            .mapError { error in
                error.handleDecodingError()
                return error as? AttendanceError ?? .decodingError
            }
            .eraseToAnyPublisher()
    }
    
    /// 출석 코드 생성 (스터디장만 가능)
    func createAttendanceCode(studyId: String, session: Int) -> AnyPublisher<Int, AttendanceError> {
        provider.requestPublisher(.createCode(studyId: studyId, session: session))
            .tryMap { response in
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                      let code = json["code"] as? Int else {
                    throw AttendanceError.decodingError
                }
                return code
            }
            .mapError { error in
                if let attendanceError = error as? AttendanceError {
                    return attendanceError
                } else {
                    return AttendanceError.unknownError(statusCode: (error as NSError).code)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 출석 코드 입력
    func submitAttendanceCode(studyId: String, code: Int) -> AnyPublisher<Bool, AttendanceError> {
        provider.requestPublisher(.enterCode(studyId: studyId, code: code))
            .tryMap { response in
                guard (200...201).contains(response.statusCode) else {
                    if response.statusCode == 401 {
                        throw AttendanceError.invalidCode
                    } else if response.statusCode == 403 {
                        throw AttendanceError.timeout
                    } else {
                        throw AttendanceError.unknownError(statusCode: response.statusCode)
                    }
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let message = json?["message"] as? String, message == "Success" {
                        return true
                    } else {
                        return false
                    }
                } catch {
                    throw AttendanceError.decodingError
                }
            }
            .mapError { error in
                if let attendanceError = error as? AttendanceError {
                    return attendanceError
                } else {
                    return AttendanceError.unknownError(statusCode: (error as NSError).code)
                }
            }
            .eraseToAnyPublisher()
    }
}

enum AttendanceError: Error, Equatable {
    case attendanceNotFound
    case invalidCode
    case timeout
    case encodingError
    case decodingError
    case unknownError(statusCode: Int)
    
    var errorMessage: String {
        switch self {
        case .attendanceNotFound:
            return "진행 중인 출석을 찾을 수 없습니다"
        case .invalidCode:
            return "코드가 올바르지 않습니다"
        case .timeout:
            return "출석 인증 시간이 초과되었습니다"
        case .encodingError:
            return "데이터 인코딩 중 에러가 발생했습니다"
        case .decodingError:
            return "데이터 디코딩 중 에러가 발생했습니다"
        case .unknownError(let statusCode):
            return "ErrorCode: \(statusCode) 지정되지 않은 에러입니다"
        }
    }
}
