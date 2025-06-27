//
//  UserInfoSetupViewModel.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import Combine
import Foundation
import PhotosUI
import Factory

final class UserInfoSetupViewModel: ObservableObject {
    
    @Injected(\.createUserInfoUseCase) private var createUserInfoUseCase
    
    @Published var isLoading: Bool = false
    @Published var contentData: [UserInfoSetupContent] = UserInfoSetupContent.generate()
    @Published var canGoNext: [Bool] = [
        false,  // 지역 설정
        false,  // 관심사 (스킵 가능)
        false,  // 프로필 사진
        false,  // 생년월일
        false   // 직업
    ]
    @Published var showCompleteView: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Active Area Setting View
    // 지역 재 선택시 기존의 데이터 리셋
    @Published var showAreaSelectModal: Bool = false {
        didSet {
            if showAreaSelectModal {
                resetSelectedAreas()
            }
        }
    }
    @Published var selectedCity: String?
    @Published var selectedDistrict: String?
    @Published var selectedsubDistricts: String?
    @Published var noMoreAreaData: Bool = false
    
    private func resetSelectedAreas() {
        selectedCity = nil
        selectedDistrict = nil
        selectedsubDistricts = nil
    }
    
    var selectedArea: [String?] {
        [selectedCity, selectedDistrict, selectedsubDistricts]
    }
    
    // MARK: - Interest Setting View
    @Published var selectedInterestIndex: [Int] = []
    
    // MARK: - Profile Setting View
    @Published var userName: String = ""
    @Published var isNameValid: Bool = false
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool = false
    @Published var hasStartedEditing: Bool = false
    
    // MARK: - Birth Setting View
    @Published var yearDigits: [String] = ["", "", "", ""]
    @Published var isYearValid: Bool = true
    @Published var combinedYear: String = ""
    
    // MARK: - Job Setting View
    @Published var selectedJobIndex: [Int] = []
    
    func createUserInfo() {
        isLoading = true

        let uploadPublisher: AnyPublisher<String, Error>
        
        // 사용자가 이미지를 선택했다면 업로드 후 S3 bucket URL, 선택하지 않았다면 빈 문자열
        if let selectedImage = selectedImage {
            uploadPublisher = AWSS3Manager.shared.upload(image: selectedImage)
        } else {
            uploadPublisher = Just("")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        uploadPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] uploadedImageUrl -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
                }

                let vo = UserInfoVO(
                    selectedArea: self.selectedArea,
                    selectedInterestIndex: self.selectedInterestIndex,
                    userName: self.userName,
                    profileImageUrl: uploadedImageUrl,
                    birthYear: self.combinedYear,
                    selectedJobIndex: self.selectedJobIndex
                )

                return self.createUserInfoUseCase.execute(userInfoVO: vo)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.isLoading = false
                    print("회원가입 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                self.isLoading = false
                if isSuccess {
                    self.showCompleteView = true
                    UserDefaultsManager.shared.setIsLoggedIn(true)
                } else {
                    fatalError("회원가입 문제 발생")
                }
            }
            .store(in: &cancellables)
    }
}
