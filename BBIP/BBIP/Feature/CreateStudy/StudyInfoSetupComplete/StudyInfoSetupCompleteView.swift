//
//  StudyInfoSetupCompleteView.swift
//  BBIP
//
//  Created by 이건우 on 8/31/24.
//

import SwiftUI
import LinkNavigator

struct StudyInfoSetupCompleteView: View {
    private let navigator: LinkNavigatorType
    
    @EnvironmentObject private var appState: AppStateManager
    @State private var showDismissButton: Bool = false
    
    private let studyId: String
    private let studyInviteCode: String
    
    init(
        navigator: LinkNavigatorType,
        studyId: String,
        studyInviteCode: String
    ) {
        self.navigator = navigator
        self.studyId = studyId
        self.studyInviteCode = studyInviteCode
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    /// `StartGuide` 화면에서 진입했을 때
                    if navigator.currentPaths.last == BBIPMatchPath.studyInfoSetupComplete.capitalizedPath {
                        UserDefaultsManager.shared.setIsExistingUser(true)
                        navigator.replace(paths: [BBIPMatchPath.home.capitalizedPath], items: [:], isAnimated: true)
                    } else {
                        /// 홈 화면에서 진입했을 때 (appState 사용)
                        /// 추후 `MainHome` 하위 뷰도 `LinkNavigator`로 변경 예정
                        appState.popToRoot()
                    }
                } label: {
                    Image("xmark")
                }
                .opacity(showDismissButton ? 1 : 0)
                .padding(.trailing, 28)
            }
            .frame(height: 42)
            
            Group {
                Text("스터디 생성이 완료되었습니다")
                    .font(.bbip(.title4_sb24))
                    .foregroundStyle(.mainWhite)
                    .padding(.top, 73)
                    .padding(.bottom, 10)
                
                Text("아래 버튼을 눌러 팀원에게 참여 링크를 공유하세요")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray6)
                    .padding(.bottom, 69)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            BBIPLottieView(assetName: "Complete_CreateStudy", contentMode: .scaleAspectFill)
                .frame(width: UIScreen.main.bounds.width - 50)
            
            ShareLink(item: URL(string: "https://bbip.site/join-study/\(studyInviteCode)")!) {
                Text("공유하기")
                    .font(.bbip(.button1_m20))
                    .foregroundColor(.mainWhite)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 56)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary3))
                    .padding(.bottom, 22)
                    .padding(.top, 69)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.gray9)
        .navigationBarBackButtonHidden()
        .onAppear {
            HapticManager.shared.boong()
            
            // 2초 후에 X버튼을 표시
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { showDismissButton = true }
            }
        }
    }
}
