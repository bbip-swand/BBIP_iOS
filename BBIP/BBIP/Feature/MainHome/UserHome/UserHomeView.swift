//
//  UserHomeView.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import SwiftUI

struct UserHomeView: View {
    @ObservedObject private var viewModel: MainHomeViewModel
    
    @State private var timeRingStart: Bool = false
    @State private var isRefresh: Bool = false
    
    init(viewModel: MainHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            NoticeBannerView(pendingNotice: "이번 주 스터디는 대체공휴일로 하루 쉬어가겠습니다!")
                .padding(.top, 22)
                .padding(.bottom, 35)
                .redacted(reason: isRefresh ? .placeholder : [])
            
            if timeRingStart {
                ActivatedBBIPTimeRingView(
                    studyTitle: "TOEIC / IELTS",
                    remainingTime: 20) {
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
                .onTapGesture {
                    withAnimation { timeRingStart = true }
                }
            }
            
            mainBulletn
                .padding(.top, 36)
                .padding(.bottom, 32)
                .redacted(reason: isRefresh ? .placeholder : [])
            
            currentWeekStudy
                .padding(.bottom, 32)
                .redacted(reason: isRefresh ? .placeholder : [])
            
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
            isRefresh = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isRefresh = false }
            }
        }
        .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
            scrollView.showsVerticalScrollIndicator = false
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
                    ForEach(0..<viewModel.homeBulletnData.count, id: \.self) { index in
                        HomeBulletnboardCell(vo: viewModel.homeBulletnData[index])
                    }
                }
                .padding(.horizontal, 17)
                .frame(height: 120)
            }
            .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
                scrollView.showsHorizontalScrollIndicator = false
            }
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
                ForEach(0..<viewModel.currentWeekStudyData.count, id: \.self) { index in
                    CurrentWeekStudyInfoCardView(vo: viewModel.currentWeekStudyData[index])
                }
            }
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
                    ForEach(0..<viewModel.commingScheduleData.count, id: \.self) { index in
                        CommingScheduleCardView(vo: viewModel.commingScheduleData[index])
                    }
                }
                .padding(.horizontal, 17)
                .frame(height: 150)
            }
            .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
}