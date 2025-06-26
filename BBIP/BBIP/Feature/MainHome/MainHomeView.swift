//
//  HomeView.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI
import LinkNavigator

struct MainHomeView: View {
    let navigator: LinkNavigatorType
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var userHomeViewModel = DIContainer.shared.makeUserHomeViewModel()
    @State private var selectedTab: MainHomeTab = .userHome
    @State private var hasLoaded: Bool = false
    
    // MARK: - Navigation Destination
    @State private var hasNotice: Bool = false
    
    private func studyNameForHeader() -> String {
        if case .studyHome(_, let studyName) = selectedTab {
            return studyName
        }
        return .init()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch selectedTab {
                    case .userHome:
                        UserHomeNavBar(navigator: navigator, showDot: $hasNotice, tabState: selectedTab)
                        UserHomeView(viewModel: userHomeViewModel, selectedTab: $selectedTab)
                    case .studyHome(let studyId, _):
                        StudyHomeView(navigator: navigator, studyId: studyId)
                    case .calendar:
                        CalendarView(ongoingStudyData: userHomeViewModel.ongoingStudyData)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            BBIPTabView(
                navigator: navigator,
                selectedTab: $selectedTab,
                ongoingStudyData: $userHomeViewModel.ongoingStudyData
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
        }
        .overlay {
            JoinStudyCompleteAlert()
                .onTapGesture {
                    appState.showJoinSuccessAlert = false
                }
                .opacity(appState.showJoinSuccessAlert ? 1 : 0)
        }
        .onAppear {
            print("mainHome OnAppear")
            appState.setLightMode()
        }
        .navigationDestination(for: MainHomeViewDestination.self) { destination in
            switch destination {
            //case .notice:
                //NoticeView()
            case .mypage:
                MypageView()
//            case .startSIS:
//                StartCreateStudyView()
            case .setLocation(let prevLocation, let studyId, let session):
                SetStudyLocationView(prevLocation: prevLocation, studyId: studyId, session: session)
            case .createCode (let studyId, let session):
                CreateCodeOnboardingView(studyId: studyId, session: session)
            case .entercode(let remainingTime, let studyId, let studyName):
                AttendanceCertificationView(remainingTime: remainingTime, studyId: studyId, studyName: studyName)
            case .showPostingList(let studyId, let postData, let weeklyStudyContent):
                PostingListView(studyId: studyId, postData: postData, weeklyStudyContent: weeklyStudyContent)
            default:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
