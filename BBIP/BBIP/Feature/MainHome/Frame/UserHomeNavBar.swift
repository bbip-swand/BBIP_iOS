import Foundation
import SwiftUI
import LinkNavigator

struct UserHomeNavBar: View {
    let navigator: LinkNavigatorType
    @EnvironmentObject var appState: AppStateManager
    @Binding var showDot: Bool
    var tabState: MainHomeTab

    var body: some View {
        if tabState != .calendar {
            HStack(spacing: 0) {
                Text("홈")
                    .font(.bbip(.title3_m20))
                    .foregroundStyle(.mainBlack)
                    .frame(maxWidth: titleMaxWidth, alignment: .leading)
                    .padding(.leading, 20)

                Spacer()
                HStack(spacing: 24) {
                    // NEXT VERSION
                    // noticeButton
                    profileButton
                }
            }
            .frame(height: 42)
            .background(.gray1)
        }
    }
    
    private var titleMaxWidth: CGFloat {
        UIScreen.main.bounds.width - 144
    }

    private var noticeButton: some View {
        Button {
            // navigator.next(paths: [BBIPMatchPath.notice.capitalizedPath], items: [:], isAnimated: true)
        } label: {
            Image("notice_icon")
                .renderingMode(.template)
                .foregroundStyle(.mainBlack)
                .overlay(
                    Group {
                        if showDot {
                            Circle()
                                .fill(.primary3)
                                .frame(width: 3.5, height: 3.5)
                                .offset(x: 2, y: -3)
                        }
                    },
                    alignment: .topTrailing
                )
        }
    }

    private var profileButton: some View {
        Button {
            appState.push(.mypage)
            // navigator.next(paths: [BBIPMatchPath.myPage.capitalizedPath], items: [:], isAnimated: true)
        } label: {
            Image("profile_icon")
                .renderingMode(.template)
                .foregroundStyle(.mainBlack)
                .padding(.trailing, 28)
        }
    }
}
