//
//  UserRepository.swift
//  BBIP
//
//  Created by 이건우 on 9/7/24.
//

import Foundation
import Combine

protocol UserRepository {
    func signUp(signUpDTO: SignUpRequestDTO) -> AnyPublisher<SignUpResponseDTO, Error>
    func resign() -> AnyPublisher<Bool, Error>
    func createUserInfo(userInfoVO: UserInfoVO) -> AnyPublisher<Bool, Error>
    func updateUserInfo(userInfoVO: UserInfoVO) -> AnyPublisher<Bool, Error>
    func getProfileInfo() -> AnyPublisher<UserInfoVO,Error>
}

final class UserRepositoryImpl: UserRepository {
    
    private let dataSource: UserDataSource
    private let mapper: UserInfoMapper
    private let getprofilemapper : GetProfileMapper

    init(
        dataSource: UserDataSource,
        mapper: UserInfoMapper,
        getprofilemapper : GetProfileMapper
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
        self.getprofilemapper = getprofilemapper
    }

    func signUp(signUpDTO: SignUpRequestDTO) -> AnyPublisher<SignUpResponseDTO, Error> {
        dataSource.requestSignUp(signUpReqDTO: signUpDTO)
            .eraseToAnyPublisher()
    }
    
    func resign() -> AnyPublisher<Bool, Error> {
        dataSource.requestResign()
            .eraseToAnyPublisher()
    }

    func createUserInfo(userInfoVO: UserInfoVO) -> AnyPublisher<Bool, Error> {
        let dto = mapper.toDTO(vo: userInfoVO)
        return dataSource.createUserInfo(userInfoDTO: dto)
            .eraseToAnyPublisher()
    }

    func updateUserInfo(userInfoVO: UserInfoVO) -> AnyPublisher<Bool, Error> {
        let dto = mapper.toDTO(vo: userInfoVO)
        return dataSource.updateUserInfo(userInfoDTO: dto)
            .eraseToAnyPublisher()
    }
    
    func getProfileInfo() -> AnyPublisher<UserInfoVO, any Error>{
        dataSource.getUserInfo()
            .map{dto in
                print ("Mapped profileDTO : \(dto)")
                return self.getprofilemapper.toVO(dto: dto)
            }
            .eraseToAnyPublisher()
    }
}

