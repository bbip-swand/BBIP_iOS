//
//  CreatePostingViewModel.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI
import Combine

final class CreatePostingViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var week: Int = -1
    @Published var isNotice: Bool = false
    
    @Published var canUpload: Bool = false
    @Published var isUploading: Bool = false
    @Published var uploadSuccess: Bool = false
    
    private let createPostingUseCase: CreatePostingUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(createPostingUseCase: CreatePostingUseCaseProtocol) {
        self.createPostingUseCase = createPostingUseCase
        setupValidationBindings()
    }
    
    func uploadPosting(studyId: String, isNotice: Bool = false) {
        guard canUpload else { return }
        
        isUploading = true
        let dto = CreatePostingDTO(
            studyId: studyId,
            title: title,
            week: week,
            content: content,
            isNotice: isNotice
        )
        
        isUploading = true
        
        createPostingUseCase.execute(dto: dto)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isUploading = false
                case .failure(let error):
                    self.isUploading = false
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                self.isUploading = false
                self.uploadSuccess = isSuccess
            })
            .store(in: &cancellables)
    }
    
    // Validation 설정
    private func setupValidationBindings() {
        Publishers.CombineLatest4($title, $content, $week, $isNotice)
            .map { title, content, week, isNotice in
                return !title.isEmpty && title.count <= 20 &&
                !content.isEmpty && content.count <= 300 && (
                week > 0 || isNotice )
            }
            .assign(to: &$canUpload)
    }
}
