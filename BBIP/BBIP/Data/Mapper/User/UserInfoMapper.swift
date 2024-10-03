//
//  UserInfoMapper.swift
//  BBIP
//
//  Created by 이건우 on 9/7/24.
//

import Foundation

struct UserInfoMapper {
    func toDTO(vo: UserInfoVO) -> UserInfoDTO {
        return UserInfoDTO(
            name: vo.userName,
            profileImageUrl: vo.profileImageUrl,
            location: vo.selectedArea.compactMap{ $0 },
            interest: vo.selectedInterestIndex,
            occupation: vo.selectedJobIndex.first!,
            birthYear: Int(vo.birthYear)!
        )
    }
}

struct GetProfileMapper{
    func toVO(dto: ProfileDTO) -> UserInfoVO{
        return UserInfoVO(
            selectedArea: dto.location ,
            selectedInterestIndex: dto.interest,
            userName: dto.name,
            profileImageUrl: dto.profileImageUrl ?? "profile_default",
            birthYear: String(dto.birthYear),
            selectedJobIndex: [dto.occupation]
        )
    }
}
