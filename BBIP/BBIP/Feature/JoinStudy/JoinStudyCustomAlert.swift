//
//  JoinStudyCustomAlert.swift
//  BBIP
//
//  Created by 이건우 on 9/25/24.
//

import SwiftUI
import Combine

struct JoinStudyCustomAlert: View {
    @ObservedObject var viewModel: JoinStudyViewModel = DIContainer.shared.makeJoinStudyViewModel()
    @ObservedObject var appState: AppStateManager
    
    @State private var cancellables = Set<AnyCancellable>()
    private let inviteData: DeepLinkAlertData
    private let calcWidth: CGFloat = UIScreen.main.bounds.width - 70
    
    private let ation: () -> Void
    
    init(
        appState: AppStateManager,
        inviteData: DeepLinkAlertData,
        @ViewBuilder action: @escaping () -> Void = {}
    ) {
        self.appState = appState
        self.inviteData = inviteData
        self.ation = action
    }
    
    private func handleJoinStudy() {
        if appState.state != .home {
            UserDefaultsManager.shared.setIsExistingUser(true)
            appState.switchRoot(.home)
        }
        withAnimation { appState.showDeepLinkAlert = false }
        withAnimation { appState.showJoinSuccessAlert = true }
        ation()
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.gray1)
                .frame(maxHeight: 310)
                .frame(width: calcWidth)
                .cornerRadius(12, corners: .allCorners)
                .overlay(alignment: .top) {
                    Rectangle()
                        .foregroundStyle(.gray8)
                        .frame(maxHeight: 90)
                        .frame(width: calcWidth)
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                }
            
            VStack(spacing: 0) {
                LoadableImageView(imageUrl: inviteData.imageUrl, size: 100)
                    .radiusBorder(cornerRadius: 100, color: .gray6)
                    .padding(.top, 30)
                
                Text(inviteData.studyName)
                    .font(.bbip(.title3_sb20))
                    .padding(.vertical, 10)
                    .foregroundStyle(.mainBlack)
                
                Text(inviteData.studyDescription ?? "")
                    .font(.bbip(.caption2_m12))
                    .foregroundStyle(.gray6)
                    .frame(width: calcWidth - 56, height: 50, alignment: .top)
                    .padding(.bottom, 22)
                
                HStack(spacing: 8) {
                    Button {
                        withAnimation { appState.showDeepLinkAlert = false }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.mainWhite)
                                .radiusBorder(cornerRadius: 12, color: .gray3)
                            
                            Text("취소")
                                .font(.bbip(.button2_m16))
                                .foregroundStyle(.primary3)
                        }
                    }
                    
                    Button {
                        viewModel.joinStudy(studyId: inviteData.studyId)
                            .sink { isSuccess in
                                if isSuccess {
                                    handleJoinStudy()
                                } else {
                                    appState.showJoinFailAlert = true
                                }
                            }
                            .store(in: &cancellables)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.primary3)
                            
                            Text("참여하기")
                                .font(.bbip(.button2_m16))
                                .foregroundStyle(.mainWhite)
                        }
                    }
                }
                .frame(width: calcWidth - 30, height: 48)
                .padding(.bottom, 13)
            }
            .frame(maxHeight: 310)
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.mainBlack.opacity(0.2))
    }
}
