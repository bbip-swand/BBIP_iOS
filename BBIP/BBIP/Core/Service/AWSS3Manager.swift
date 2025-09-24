//
//  AWSS3Manager.swift
//  BBIP
//
//  Created by 이건우 on 9/4/24.
//

import Combine
import Foundation
import UIKit
import Moya

final class AWSS3Manager {
    static let shared = AWSS3Manager()
    private let provider = MoyaProvider<AWSS3API>(plugins: [TokenPlugin(), LoggerPlugin()])
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Upload Image
    func upload(image: UIImage) -> AnyPublisher<String, Error> {
        let uuid = UUID().uuidString
        
        // Presigned URL 요청 후, 이미지 업로드 및 최종 URL 반환
        return requestImagePresignedURL(with: uuid)
            .flatMap { [weak self] urlString -> AnyPublisher<String, Error> in
                guard let self = self, let imageData = image.jpegData(compressionQuality: 1) else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }
                BBIPLogger.log(urlString, level: .info, category: .feature(featureName: "AWSS3 Presigned URL"))
                
                // 이미지 업로드 후 final URL 반환
                return self.uploadImageToBinary(imageData: imageData, urlString: urlString)
                    .map { _ in
                        let finalURL = "https://storage.googleapis.com/bbip-bucket/images/\(uuid)"
                        return finalURL
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // Presigned URL 요청
    private func requestImagePresignedURL(with uuid: String) -> AnyPublisher<String, Error> {
        return provider.requestPublisher(.requestImagePresignedUrl(fileName: uuid))
            .map(BaseResponseDTO<String>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // presigned URL에 이미지 업로드
    private func uploadImageToBinary(imageData: Data, urlString: String) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.upload(fileData: imageData, url: urlString, fileType: "image/jpeg"))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    print(response.statusCode)
                    throw URLError(.badServerResponse)
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Upload File
    
    // Function to upload file with success/failure check
    func upload(file: Data, fileName: String, fileKey: String, studyId: String) -> AnyPublisher<Bool, Error> {
        // Request Presigned URL for file
        return requestFilePresignedURL(fileName: fileName, fileKey: fileKey, studyId: studyId)
            .flatMap { [weak self] urlString -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }
                BBIPLogger.log(urlString, level: .info, category: .feature(featureName: "AWSS3 Presigned URL"))
                
                // Upload file and return success or failure as Bool
                return self.uploadFileToBinary(fileData: file, urlString: urlString)
                    .map { _ in true } // Return true if upload is successful
                    .catch { _ in Just(false).setFailureType(to: Error.self).eraseToAnyPublisher() } // Return false if upload fails
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // Presigned URL 요청 for Files
    private func requestFilePresignedURL(fileName: String, fileKey: String, studyId: String) -> AnyPublisher<String, Error> {
        return provider.requestPublisher(.requestFilePresignedUrl(fileName: fileName, fileKey: fileKey, studyId: studyId))
            .map(BaseResponseDTO<String>.self, using: JSONDecoder())
            .map(\.data)
            .mapError { error in
                error.handleDecodingError()
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // presigned URL에 파일 업로드
    private func uploadFileToBinary(fileData: Data, urlString: String) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.upload(fileData: fileData, url: urlString))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    print(response.statusCode)
                    throw URLError(.badServerResponse)
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
}
