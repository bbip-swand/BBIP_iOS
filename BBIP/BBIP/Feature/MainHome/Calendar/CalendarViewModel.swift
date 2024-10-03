//
//  CalendarViewModel.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import Foundation
import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject{
    //
    @Published var commingScheduleData: [CommingScheduleVO] = []
    @Published var mystudies: [selectStudyVO] = []
    //UpdateSchedule
   
    
    var cancellables = Set<AnyCancellable>()
    //MARK: - get upcoming
    @Published var getUpcomingData: [CalendarHomeVO] = []
    @Published var getYMdata: [CalendarHomeVO] = []
    @Published var getDdata: [CalendarHomeVO] = []
    
    
    //UseCase
    private let getScheduleYMUseCase: GetYMUseCaseProtocol
    private let getScheduleDUseCase: GetDateUseCaseProtocol
    private let getUpcomingUseCase: GetUpcomingUseCaseProtocol
    private let createScheduleUseCase: CreateScheduleUseCaseProtocol
    private let updateScheduleUseCase: UpdateScheduleUseCaseProtocol
    private let getMyStudyUseCase: GetMyStudyUseCaseProtocol
    
    init(
        getScheduleYMUseCase: GetYMUseCaseProtocol,
        getScheduleDUseCase: GetDateUseCaseProtocol,
        getUpcomingUseCase: GetUpcomingUseCaseProtocol,
        createScheduleUseCase: CreateScheduleUseCaseProtocol,
        updateScheduleUseCase: UpdateScheduleUseCaseProtocol,
        getMyStudyUseCase: GetMyStudyUseCaseProtocol,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    ){
        self.cancellables = cancellables
        self.getUpcomingUseCase = getUpcomingUseCase
        self.getScheduleDUseCase = getScheduleDUseCase
        self.getScheduleYMUseCase = getScheduleYMUseCase
        self.createScheduleUseCase = createScheduleUseCase
        self.getMyStudyUseCase = getMyStudyUseCase
        self.updateScheduleUseCase = updateScheduleUseCase
    }    
    //MARK: -getMystudy
    func getMystudy(){
        getMyStudyUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink{completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load mystudy records: \(error.localizedDescription)")
                }
            }receiveValue: { [weak self] records in
                guard let self = self else { return }
                self.mystudies = records // 받은 상태 정보를 저장
                print("getMystudy: \(records)")
            }
            .store(in: &cancellables)
    }
    
    //MARK: -getUpcoming
    func getUpcoming(){
        getUpcomingUseCase.execute()
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드에서 받음
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load getUpcoming status: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.getUpcomingData = response
                print("getUpcomingData : \(response)")
                
                self.commingScheduleData = response
                                .filter { $0.isHomeView }
                                .map {
                                    CommingScheduleVO(iconType: $0.icon, leftDay: $0.leftDays, scheduleTitle: $0.scheduleTitle)
                                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: -getYear
    func getYearMonth(year: String, month: String){
        getScheduleYMUseCase.execute(year: year, month: month)
            .receive(on: DispatchQueue.main)
            .sink{completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load getYerMonth records: \(error.localizedDescription)")
                }
            }receiveValue: { [weak self] records in
                guard let self = self else { return }
                self.getYMdata = records // 받은 상태 정보를 저장
                print("getYearMonthSChedule: \(records)")
            }
            .store(in: &cancellables)
    }
    
    //MARK: -getDate
    func getDate(date: String){
        getScheduleDUseCase.execute(date: date)
            .receive(on: DispatchQueue.main)
            .sink{completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    error.handleDecodingError()
                    print("fail load getDate records: \(error.localizedDescription)")
                }
            }receiveValue: { [weak self] records in
                guard let self = self else { return }
                self.getDdata = records // 받은 상태 정보를 저장
                print("getDateSchedule: \(records)")
            }
            .store(in: &cancellables)
    }
    
    //MARK: -createSchedule
    func createSchedule(scheduleVO: CreateScheduleVO) {
        createScheduleUseCase.execute(calendarVO: scheduleVO)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("스케줄 생성 성공")
                case .failure(let error):
                    error.handleDecodingError()
                    print("스케줄 생성 실패: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // 스케줄 생성 후 필요한 추가 작업이 있다면 여기에 작성
            }
            .store(in: &cancellables)
    }
    
    //MARK: -putSchedule
    func updateSchedule(scheduleId:String, scheduleVO: CreateScheduleVO) {
        updateScheduleUseCase.execute(scheduleId: scheduleId, calendarVO: scheduleVO)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("스케줄 업데이트 성공")
                case .failure(let error):
                    error.handleDecodingError()
                    print("스케줄 업데이트 실패: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // 스케줄 생성 후 필요한 추가 작업이 있다면 여기에 작성
            }
            .store(in: &cancellables)
    }
}
