//
//  StudyHomeView.swift
//  BBIP
//
//  Created by 이건우 on 9/24/24.
//

import SwiftUI
import Combine

struct StudyHomeView: View {
    @StateObject private var viewModel: StudyHomeViewModel = DIContainer.shared.makeStudyHomeViewModel()
    
    @State private var showDetailView: Bool = false
    @State private var showArchiveView: Bool = false
    private let studyId: String
    
    init(studyId: String) {
        self.studyId = studyId
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            navBar
                .zIndex(2)
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                        .zIndex(1)
                    
                    StudyHomeInnerView {
                        coreFeatureButtons
                            .padding(.top, 50)
                            .padding(.bottom, 27)
                            .padding(.horizontal, 17)
                        
                        studyProgress
                            .padding(.bottom, 32)
                            .padding(.horizontal, 17)
                            .id(viewModel.isFullInfoLoaded)
                        
                        weeklyContent
                            .padding(.bottom, 32)
                            .padding(.horizontal, 17)
                        
                        studyBulletn
                            .padding(.bottom, 32)
                        
                        studyMember
                    }
                    .frame(height: 1100)
                    
                    Spacer()
                }
            }
            .padding(.top, 54)
            .background(
                VStack(spacing: 0) {
                    Color.gray9
                        .frame(height: 400)
                        .ignoresSafeArea(edges: .top)
                    Color.gray1
                }
            )
            .frame(maxHeight: .infinity)
            .scrollIndicators(.never)
            .introspect(.scrollView, on: .iOS(.v17, .v18)) { scrollView in
                scrollView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                scrollView.refreshControl?.tintColor = .primary3
            }
        }
        .refreshable {
            viewModel.reloadFullStudyInfo(studyId: studyId)
        }
        .onAppear {
            viewModel.requestFullStudyInfo(studyId: studyId)
            viewModel.getStudyPosting(studyId: studyId)
        }
        .onChange(of: studyId) { _, newVal in
            viewModel.reloadFullStudyInfo(studyId: newVal)
        }
        .navigationDestination(isPresented: $showDetailView) {
            if let vo = viewModel.fullStudyInfo {
                StudyDetailView(vo: vo)
            }
        }
        .navigationDestination(isPresented: $showArchiveView) {
            ArchiveView(studyId: studyId)
        }
    }
    
    private var navBar: some View {
        HStack {
            if let studyName = viewModel.fullStudyInfo?.studyName {
                Text(studyName)
                    .font(.bbip(.title4_sb24))
                    .foregroundColor(.mainWhite)
                    .padding(.leading, 20)
            } else {
                Text("studyName")
                    .font(.bbip(.title4_sb24))
                    .foregroundColor(.mainWhite)
                    .padding(.leading, 20)
                    .redacted(reason: .placeholder)
            }
            
            Spacer()
            
            Button {
                showDetailView = true
            } label: {
                Image("more")
                    .foregroundColor(.mainWhite)
                    .padding(.trailing, 20)
            }

        }
        .frame(height: 42)
        .background(Color.gray9)
        .animation(.easeInOut, value: viewModel.fullStudyInfo?.studyName)
    }

    private var headerView: some View {
        ZStack() {
            Color.gray9
                .frame(height: 320)
                .overlay(alignment: .bottomTrailing) {
                    Image("boxing_ring")
                        .offset(y: 37)
                        .zIndex(1)
                }
            VStack(spacing: 0) {
                NoticeBannerView(pendingNotice: "다음주 스터디 하루 쉬어갑니다! 확인 해주세요...!", isDark: true)
                    .padding(.top, 22)
                    .padding(.bottom, 28)
                
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 30, height: 24)
                        .foregroundStyle(.primary3)
                        .overlay {
                            if let currentWeek = viewModel.fullStudyInfo?.currentWeek {
                                Text(currentWeek.description + "R")
                                    .font(.bbip(.caption2_m12))
                            } else {
                                Text("currentWeekPlaceholder")
                                    .redacted(reason: .placeholder)
                            }
                        }
                    
                    if let currentContent = viewModel.fullStudyInfo?.currentWeekContent {
                        if currentContent.isEmpty {
                            Text("미정")
                                .font(.bbip(.body2_m14))
                                .foregroundStyle(.gray5)
                        } else {
                            Text(currentContent)
                                .font(.bbip(.body2_m14))
                                .frame(maxWidth: UIScreen.main.bounds.width - 160, maxHeight: 20, alignment: .leading)
                        }
                    } else {
                        Text("currentContentPlaceholder")
                            .redacted(reason: .placeholder)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
                .foregroundStyle(.mainWhite)
                
                HStack(spacing: 10) {
                    Image("study_calendar")
                        .renderingMode(.template)
                        .foregroundColor(.gray6)
                    
                    if let dateStr = viewModel.fullStudyInfo?.pendingDateStr {
                        Text(dateStr + " / " + viewModel.fullStudyInfo!.pendingDateTimeStr)
                            .font(.bbip(.caption2_m12))
                            .foregroundStyle(.gray2)
                    } else {
                        Text("0월 0일 (0) / 00:00 ~ 00:00")
                            .foregroundStyle(.gray2)
                            .redacted(reason: .placeholder)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .frame(maxHeight: 320)
        }
        .animation(.easeInOut, value: viewModel.isFullInfoLoaded)
    }
    
    private var coreFeatureButtons: some View {
        HStack {
            VStack(spacing: 12) {
                Button {
                    // go attendance
                } label: {
                    Image("studyHome_attendance")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Text("출석 인증")
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    // go location
                } label: {
                    Image("studyHome_location")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Text("장소 확인")
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    showArchiveView = true
                } label: {
                    Image("studyHome_archive")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Text("아카이브")
            }
        }
        .font(.bbip(.button2_m16))
        .padding(.horizontal, 33)
    }
    
    private var studyProgress: some View {
        VStack(spacing: 12) {
            HStack {
                Text("스터디 진척도")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                    .padding(.leading, 11)
                
                Spacer()
            }
            
            if let totalWeek = viewModel.fullStudyInfo?.totalWeeks {
                StudyProgressBar(
                    totalWeek: totalWeek,
                    currentWeek: viewModel.fullStudyInfo!.currentWeek,
                    periodString: viewModel.fullStudyInfo!.studyPeriodString
                )
            } else {
                StudyProgressBar(
                    totalWeek: 1,
                    currentWeek: 0,
                    periodString: "placeholderplaceholder"
                )
                .redacted(reason: .placeholder)
            }
        }
        .animation(.easeInOut, value: viewModel.fullStudyInfo?.totalWeeks)
    }
    
    private var weeklyContent: some View {
        VStack(spacing: 12) {
            HStack {
                Text("주차별 활동")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                    .padding(.leading, 11)
                
                Spacer()
            }
            
            if let fullStudyInfo = viewModel.fullStudyInfo {
                let currentWeek = fullStudyInfo.currentWeek - 1 // 0-based index
                let totalWeeks = fullStudyInfo.totalWeeks
                let contents = fullStudyInfo.studyContents
                let remainingWeeks = totalWeeks - currentWeek
                let maxWeeks = min(3, remainingWeeks)
                
                // Start date (first week's date)
                let startDate = calculateStartDate(from: fullStudyInfo.pendingDateStr)
                
                ForEach(0..<maxWeeks, id: \.self) { index in
                    let weekIndex = currentWeek + index
                    let content = contents[weekIndex]
                    
                    // Calculate date for each week by adding 'index' weeks to the startDate
                    let weekDate = formatDate(from: startDate.addingTimeInterval(TimeInterval(7 * index * 24 * 60 * 60)))
                    VStack(alignment: .leading, spacing: 5) {
                        WeeklyStudyContentCell(weekVal: weekIndex + 1, content: content, dateStr: weekDate, isCurrentWeek: index == 0)
                    }
                }
            } else {
                ForEach(0..<3, id: \.self) { index in
                    WeeklyStudyContentCell(weekVal: index, content: "placeholder", dateStr: "00월 00일 (0)", isCurrentWeek: false)
                        .redacted(reason: .placeholder)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.fullStudyInfo?.studyContents)
    }
    
    private var studyBulletn: some View {
        VStack(spacing: 12) {
            HStack {
                Text("게시판")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                    .padding(.leading, 28)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    if viewModel.studyBulletnData == nil {
                        ForEach(0..<5, id: \.self) { _ in
                            BulletnboardCell(vo: .placeholderVO(), type: .studyHome)
                                .redacted(reason: .placeholder)
                        }
                    } else if let data = viewModel.studyBulletnData, data.isEmpty {
                        HomeBulletnboardCellPlaceholder()
                    } else if let data = viewModel.studyBulletnData {
                        ForEach(0..<data.count, id: \.self) { index in
                            BulletnboardCell(vo: data[index], type: .studyHome)
                        }
                    }
                }
                .animation(.easeInOut, value: viewModel.studyBulletnData)
                .padding(.horizontal, 17)
                .frame(height: 120)
            }
            .bbipShadow1()
        }
    }
    
    private var studyMember: some View {
        VStack(spacing: 12) {
            HStack {
                Text("스터디원")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                    .padding(.leading, 28)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    if let studyMembers = viewModel.fullStudyInfo?.studyMembers {
                        ForEach(0..<studyMembers.count, id: \.self) { index in
                            StudyMemberCell(vo: studyMembers[index])
                        }
                        
                        if let code = viewModel.fullStudyInfo?.inviteCode {
                            StudyMemberInviteCell(inviteCode: code)
                        }
                    } else {
                        ForEach(0..<4, id: \.self) { index in
                            StudyMemberCell(vo: .placeholderMock())
                                .redacted(reason: .placeholder)
                        }
                    }
                }
                .padding(.horizontal, 17)
            }
            .bbipShadow1()
        }
    }
}

private struct StudyHomeInnerView<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray1
            
            VStack {
                content
            }
        }
    }
}

extension StudyHomeView {
    func calculateStartDate(from dateString: String) -> Date {
        // Assume the date format is "MM월 dd일 (E)" -> "10월 2일 (수)"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 (E)"
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 (E)"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    StudyHomeView(studyId: "a")
}

