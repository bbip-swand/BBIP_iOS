//
//  UserHomeView.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import SwiftUI

struct UserHomeView: View {
    @StateObject var viewModel: UserHomeViewModel
    @Binding var selectedTab: MainHomeTab
    
    @State private var isRefresh: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ScrollView {
            // 공지사항
            notice
                .padding(.top, 22)
                .padding(.bottom, 35)
            
            // 메인 타임 링
            timeRing
                .padding(.bottom, 36)
                .id(viewModel.attendanceStatus?.remainingTime)
            
            // 게시판
            mainBulletn
                .padding(.bottom, 32)
            
            // 이번 주 스터디
            currentWeekStudy
                .padding(.bottom, 32)
            
            // 다가오는 일정
            commingSchedule
                .redacted(reason: isRefresh ? .placeholder : [])
                .padding(.bottom, 32)
            
            BBIPGuideButton()
            
            Spacer()
                .frame(minHeight: 150)
        }
        .frame(maxHeight: .infinity)
        .refreshable {
            // refresh
            viewModel.refreshHomeData()
            
            isRefresh = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { isRefresh = false }
            }
        }
        .scrollIndicators(.never)
        .introspect(.scrollView, on: .iOS(.v17, .v18)) { scrollView in
            scrollView.backgroundColor = .gray1
            scrollView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            scrollView.refreshControl?.tintColor = .primary3
        }
        .onAppear {
            print("userHome OnAppear")
            viewModel.loadHomeData()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.loadHomeData()
            }
        }
    }
    
    var notice: some View {
        Group {
            if let homeBulletnData = viewModel.homeBulletnData {
                NoticeBannerView(postVO: homeBulletnData.filter({ $0.postType == .notice }).first)
            } else {
                NoticeBannerView(postVO: .placeholderVO())
                    .redacted(reason: .placeholder)
            }
        }
    }
    
    var timeRing: some View {
        Group {
            if let pendingStudyData = viewModel.pendingStudyData {
                if viewModel.isAttendanceStarted {
                    if let attendanceStatus = viewModel.attendanceStatus {
                        if !attendanceStatus.isManager && attendanceStatus.isAttended {
                            // 출석 완료
                            BBIPTimeRingView(vo: pendingStudyData, isAttended: true)
                                .redacted(reason: isRefresh ? .placeholder : [])
                        } else {
                            // 출석 진행 중 (팀장은 항상 activated)
                            ActivatedBBIPTimeRingView(vo: attendanceStatus) {
                                withAnimation { viewModel.isAttendanceStarted = false }
                            }
                        }
                    }
                } else {
                    // 출석 중이 아닐 떄
                    BBIPTimeRingView(vo: pendingStudyData)
                        .redacted(reason: isRefresh ? .placeholder : [])
                        .onTapGesture {
                            selectedTab = .studyHome(studyId: pendingStudyData.studyId, studyName: pendingStudyData.studyName)
                        }
                }
            } else {
                // placeholder
                BBIPTimeRingView(vo: .mock())
                    .redacted(reason: .placeholder)
            }
        }
    }
    
    var mainBulletn: some View {
        VStack(spacing: 0) {
            HStack {
                Text("게시판")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                
                Spacer()
                
                ShowAllButton {
                    
                }
                .opacity(0) // NEXT VERSION
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
                    if let data = viewModel.upcomingScheduleData {
                        if data.isEmpty {
                            UpcommingScheduleCardViewPlaceholder()
                        } else {
                            ForEach(0..<data.count, id: \.self) { index in
                                UpcommingScheduleCardView(vo: data[index])
                                    .onTapGesture { selectedTab = .calendar }
                            }
                        }
                    } else {
                        UpcommingScheduleCardView(vo: .placeholderVO())
                            .redacted(reason: .placeholder)
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
