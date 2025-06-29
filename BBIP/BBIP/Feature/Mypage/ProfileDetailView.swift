//
//  ProfileDetailView.swift
//  BBIP
//
//  Created by 이건우 on 11/11/24.
//

import SwiftUI
import LinkNavigator

struct ProfileDetailView: View {
    let navigator: LinkNavigatorType
    @EnvironmentObject var appState: AppStateManager
    @ObservedObject var viewModel: MyPageViewModel
    @State private var showWarningAlert: Bool = false
    
    private let imageSize: CGFloat = 124
    
    var userName: String
    var profileImageUrl: String
    var parsedArea: String
    var parsedOccupation: String
    var parsedInterests: [String]
    var birthYear: String
    
    // Dynamically computed property
    private var interestsString: String {
        parsedInterests.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            profileImageSection
            userNameSection
            basicInfoSection
            additionalInfoSection
            
            Spacer()
            
            deleteAccountSection
        }
        .navigationBarTitleDisplayMode(.inline)
        .backButtonStyle()
        .navigationTitle("내 정보 관리")
        .background(.gray1)
        .alert(isPresented: $showWarningAlert) {
            Alert(
                title: Text("정말 탈퇴하시겠습니까?"),
                message: Text("회원 탈퇴 시, 회원님이 생성한 스터디는\n모두 삭제됩니다. 삭제된 정보는 되돌릴 수 없습니다."),
                primaryButton: .destructive(Text("네")) {
                    viewModel.resign() {
                        UserDefaultsManager.shared.clearUserData()
                        self.navigator.replace(paths: [BBIPMatchPath.onboarding.capitalizedPath], items: [:], isAnimated: false)
                    }
                },
                secondaryButton: .cancel(Text("아니오"))
            )
        }
    }
}

private extension ProfileDetailView {
    // Profile Image Section
    var profileImageSection: some View {
        Button {
            // Image selection logic
        } label: {
            ZStack(alignment: .bottomTrailing) {
                LoadableImageView(imageUrl: profileImageUrl, size: imageSize)
                
                /* NEXT VERSION
                Image("mypage_profile_edit")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 16.5)
                 */
            }
            .padding(.top, 30)
        }
    }
    
    // User Name Section
    var userNameSection: some View {
        Text(userName)
            .font(.bbip(.title3_m20))
            .foregroundStyle(.mainBlack)
            .padding(.top, 20)
    }
    
    // Basic Info Section
    var basicInfoSection: some View {
        VStack(spacing: 0) {
            sectionHeader(title: "기본정보")
            infoCard {
                row(title: "소셜 로그인", description: "APPLE")
            }
        }
        .padding(.top, 23)
    }
    
    // Additional Info Section
    var additionalInfoSection: some View {
        VStack(spacing: 0) {
            sectionHeader(title: "부가정보")
            infoCard(height: 179) {
                VStack(spacing: 21) {
                    row(title: "관심분야", description: interestsString)
                    row(title: "출생연도", description: birthYear)
                    row(title: "직업", description: parsedOccupation)
                    row(title: "지역", description: parsedArea)
                }
            }
        }
        .padding(.top, 21)
    }
    
    // Delete Account Section
    var deleteAccountSection: some View {
        Button {
            showWarningAlert = true
        } label: {
            Text("BBIP 탈퇴하기")
                .font(.bbip(.button2_m16))
                .foregroundStyle(.gray7)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray3, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainWhite))
                        .frame(height: 30)
                )
                .padding(.bottom, 64)
        }
    }
    
    // Section Header
    func sectionHeader(title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.bbip(.body1_b16))
                .foregroundStyle(.gray8)
            Spacer()
        }
        .padding(.leading, 28)
    }
    
    // Info Card with Customizable Height
    func infoCard<Content: View>(
        height: CGFloat = 65,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray3, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainWhite))
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(.horizontal, 16)
            
            content()
                .padding(.horizontal, 32)
        }
        .padding(.top, 12)
    }
    
    func row(
        title: String,
        description: String
    ) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray7)
                .frame(minWidth: 70, alignment: .leading)
            
            Text(description)
                .font(.bbip(.body2_m14))
                .foregroundStyle(.gray9)
                .padding(.leading, 21)
            
            Spacer()
        }
    }
}
