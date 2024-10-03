//
//  MainHomeViewModel.swift
//  BBIP
//
//  Created by 이건우 on 9/11/24.
//

import Foundation
import Combine

class MainHomeViewModel: ObservableObject {
    

    // real data
    @Published var homeBulletnData: RecentPostVO?
    @Published var currentWeekStudyData: [CurrentWeekStudyInfoVO]?
    @Published var ongoingStudyData: [StudyInfoVO]?
    
    // UseCases
    private let getCurrentWeekPostUseCase: GetCurrentWeekPostUseCaseProtocol            // 게시글
    private let getCurrentWeekStudyInfoUseCase: GetCurrentWeekStudyInfoUseCaseProtocol  // 이번 주 스터디
    private let getOngoingStudyInfoUseCase: GetOngoingStudyInfoUseCaseProtocol          // 진행중인 스터디
    private var cancellables = Set<AnyCancellable>()
    
    
    init(
        getCurrentWeekPostUseCase: GetCurrentWeekPostUseCaseProtocol,
        getCurrentWeekStudyInfoUseCase: GetCurrentWeekStudyInfoUseCaseProtocol,
        getOngoingStudyInfoUseCase: GetOngoingStudyInfoUseCaseProtocol,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
        self.getCurrentWeekPostUseCase = getCurrentWeekPostUseCase
        self.getCurrentWeekStudyInfoUseCase = getCurrentWeekStudyInfoUseCase
        self.getOngoingStudyInfoUseCase = getOngoingStudyInfoUseCase
        self.cancellables = cancellables
    }
    
    private func clearData() {
        homeBulletnData = nil
        currentWeekStudyData = nil
    }
    
    func loadHomeData() {
        getCurrentWeekPostUseCase.excute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("fail load home bulletn: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.homeBulletnData = response
            }
            .store(in: &cancellables)
        
        getCurrentWeekStudyInfoUseCase.excute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("failed load current week study: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.currentWeekStudyData = response
            }
            .store(in: &cancellables)
        
        getOngoingStudyInfoUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("failed load ongoing study: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.ongoingStudyData = response
            }
            .store(in: &cancellables)
    }
    
    func refreshHomeData() {
        clearData()
        
        // for testing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadHomeData()
        }
    }
}
