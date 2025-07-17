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
    //@State private var selectedTab: MainHomeTab = .userHome
    @State private var hasLoaded: Bool = false
    
    // MARK: - Navigation Destination
    @State private var hasNotice: Bool = false
    
    private func studyNameForHeader() -> String {
        if case .studyHome(_, let studyName) = appState.mainHomeSelectedTab {
            return studyName
        }
        return .init()
    }
    
    var body: some View {
        NavigationStack(path: $appState.path) {
        ZStack {
            VStack(spacing: 0) {
                switch appState.mainHomeSelectedTab {
                    case .userHome:
                        UserHomeNavBar(navigator: navigator, showDot: $hasNotice, tabState: appState.mainHomeSelectedTab)
                        UserHomeView(viewModel: userHomeViewModel, selectedTab: $appState.mainHomeSelectedTab)
                    case .studyHome(let studyId, _):
                        StudyHomeView(navigator: navigator, studyId: studyId)
                    case .calendar:
                        CalendarView(ongoingStudyData: userHomeViewModel.ongoingStudyData)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                BBIPTabView(
                    navigator: navigator,
                    selectedTab: $appState.mainHomeSelectedTab,
                    ongoingStudyData: $userHomeViewModel.ongoingStudyData
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.bottom)
            }
            .overlay(
                Group {
                    if let data = appState.deepLinkAlertData {
                        JoinStudyCustomAlert(
                            appState: appState,
                            inviteData: data
                        )
                        .opacity(appState.showDeepLinkAlert ? 1 : 0)
                    }
                }
            )
            .alert(isPresented: $appState.showJoinFailAlert) {
                Alert(
                    title: Text("가입 실패"),
                    message: Text("이미 가입된 스터디입니다"),
                    dismissButton: .default(Text("확인"))
                )
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
                    case .mypage:
                        MypageView(navigator: navigator)
                        
                    case .startSIS:
                        StartCreateStudyView(navigator: navigator)
                        
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
        }
        .navigationBarBackButtonHidden()
    }
}
