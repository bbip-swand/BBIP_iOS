//
//  CreateAttendanceCodeOnboardingView.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Foundation
import SwiftUI
import Combine
import Factory

struct CreateAttendanceCodeOnboardingView: View {
    
    @InjectedObject(\.createAttendanceCodeOnboardingViewModel) private var viewModel
    
    @State private var pendingCheck = false
    @State private var showCreateCodeView = false
    
    private let studyId: String
    private let session: Int
    
    init(
        studyId: String,
        session: Int
    ) {
        self.studyId = studyId
        self.session = session
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("오늘 경기에 참여하는\n팀원들의 출석 체크를 시작하세요")
                    .font(.bbip(.title4_sb24))
                    .foregroundStyle(.mainWhite)
                    .padding(.top, 72)
                
                Text("출석 인증이 시작되면 팀원에게 알림이 가요")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray6)
                    .padding(.top, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
            
            Image("create_code")
                .resizable()
                .frame(height: 186)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.bottom, 97)
            
            MainButton(text: "코드 생성하기", enable: true) {
                pendingCheck = true
                viewModel.checkIsTodayStudy(studyId: studyId)
            }
            .padding(.bottom,22)
        }
        .background(.gray9)
        .backButtonStyle(isReversal: true)
        .loadingOverlay(isLoading: $viewModel.isLoading)
        .onChange(of: viewModel.showIsNotTodayStudyWarningAlert) { _, shouldShowWarningAlert in
            if pendingCheck {
                if shouldShowWarningAlert == false {
                    showCreateCodeView = true
                }
                pendingCheck = false
            }
        }
        .navigationDestination(isPresented: $showCreateCodeView) {
            CreateAttendanceCodeView(studyId: studyId, session: session)
        }
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray9)
        }
        .alert("오늘은 진행할 스터디가 없어요", isPresented: $viewModel.showIsNotTodayStudyWarningAlert) {
            Button("취소", role: .cancel) { }
            Button("확인") {
                showCreateCodeView = true
            }
        } message: {
            Text("오늘은 스터디 진행일이 아니에요.\n그래도 출석을 시작할까요?")
        }
    }
}

