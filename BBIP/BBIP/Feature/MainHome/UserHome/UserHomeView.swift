//
//  UserHomeView.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import SwiftUI

struct UserHomeView: View {
    @StateObject var viewModel: MainHomeViewModel
    @StateObject var calviewModel = DIContainer.shared.makeCalendarVieModel()
    @EnvironmentObject var attendviewModel: AttendanceCertificationViewModel
    
    @State private var timeRingStart: Bool = false
    @State private var isRefresh: Bool = false
    @State private var attendstatusData: GetStatusVO?
    @Binding var selectedTab: MainHomeTab
    
    var body: some View {
        ScrollView {
            Group {
                if let homeBulletnData = viewModel.homeBulletnData {
                    NoticeBannerView(postVO: homeBulletnData.filter({ $0.postType == .notice }).first)
                } else {
                    NoticeBannerView(postVO: .placeholderVO())
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.top, 22)
            .padding(.bottom, 35)
           
            
            if timeRingStart {
                ActivatedBBIPTimeRingView(
                    studyTitle: attendstatusData?.studyName ?? "스터디",
                    remainingTime: $attendviewModel.remainingTime,
                    studyId: $attendviewModel.studyId,
                    session: $attendviewModel.session
                ) {
                    withAnimation { timeRingStart = false }
                }
            } else {
                BBIPTimeRingView(
                    progress: 0.4,
                    vo: .init(
                        leftDay: 0,
                        title: "TOEIC / IELTS",
                        time: "18:00 - 20:00",
                        location: "예대 4층"
                    )
                )
                .redacted(reason: isRefresh ? .placeholder : [])
            }
            
            mainBulletn
                .padding(.top, 36)
                .padding(.bottom, 32)
            
            currentWeekStudy
                .padding(.bottom, 32)
            
            commingSchedule
                .redacted(reason: isRefresh ? .placeholder : [])
                .padding(.bottom, 32)
            
            BBIPGuideButton()
            
            Spacer()
                .frame(minHeight: 150)
        }
        .frame(maxHeight: .infinity)
        .refreshable {
            viewModel.refreshHomeData()
            attendviewModel.getStatusAttend()
            calviewModel.getUpcoming()
            
            // Use DispatchQueue to ensure the values are updated before setting `timeRingStart`
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                attendstatusData = attendviewModel.getStatusData

                if let attendstatusData = attendstatusData {
                    print("새로고침 후 받은 getStatusVO 데이터: \(attendstatusData)")
                    timeRingStart = true
                }
            }
        }
        .onAppear(){
            calviewModel.getUpcoming()
        }
        .scrollIndicators(.never)
        .introspect(.scrollView, on: .iOS(.v17, .v18)) { scrollView in
            scrollView.backgroundColor = .gray1
            scrollView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            scrollView.refreshControl?.tintColor = .primary3
        }
    }
    
    var mainBulletn: some View {
        VStack(spacing: 0) {
            HStack {
                Text("게시판")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                Spacer()
                Button {
                    //
                } label: {
                    HStack(spacing: 4) {
                        Text("전체보기")
                            .font(.bbip(.body2_m14))
                        Image("detail_rightArrow")
                    }
                    .foregroundStyle(.gray7)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    if viewModel.homeBulletnData == nil {
                        ForEach(0..<5, id: \.self) { _ in
                            BulletnboardCell(vo: .placeholderVO(), type: .userHome)
                                .redacted(reason: .placeholder)
                        }
                    } else if let data = viewModel.homeBulletnData, data.isEmpty {
                        HomeBulletnboardCellPlaceholder()
                    } else if let data = viewModel.homeBulletnData {
                        ForEach(0..<data.count, id: \.self) { index in
                            BulletnboardCell(vo: data[index], type: .userHome)
                        }
                    }
                }
                .animation(.easeInOut, value: viewModel.homeBulletnData)
                .padding(.horizontal, 17)
                .frame(height: 120)
            }
            .bbipShadow1()
            .scrollIndicators(.never)
        }
    }
    
    var currentWeekStudy: some View {
        VStack(spacing: 0) {
            HStack {
                Text("이번 주 스터디")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 8) {
                
                if viewModel.currentWeekStudyData == nil {
                    ForEach(0..<3, id: \.self) { _ in
                        CurrentWeekStudyInfoCardView(vo: .placeholderVO())
                            .redacted(reason: .placeholder)
                    }
                } else if let data = viewModel.currentWeekStudyData, data.isEmpty {
                    CurrentWeekStudyInfoCardViewPlaceholder()
                } else if let data = viewModel.currentWeekStudyData {
                    ForEach(0..<data.count, id: \.self) { index in
                        CurrentWeekStudyInfoCardView(vo: data[index])
                            .onTapGesture {
                                selectedTab = .studyHome(studyId: data[index].studyId, studyName: data[index].title)
                            }
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.currentWeekStudyData)
            .padding(.horizontal, 17)
        }
    }
    
    var commingSchedule: some View {
        VStack(spacing: 0) {
            HStack {
                Text("다가오는 일정")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(0..<calviewModel.commingScheduleData.count, id: \.self) { index in
                        CommingScheduleCardView(vo: calviewModel.commingScheduleData[index])
                    }
                }
                .padding(.horizontal, 17)
                .frame(height: 150)
            }
            .bbipShadow1()
            .scrollIndicators(.never)
        }
    }
}
