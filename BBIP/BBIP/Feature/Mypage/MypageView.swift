//
//  MypageView.swift
//  BBIP
//
//  Created by 이건우 on 9/9/24.
//

import SwiftUI

struct MypageView: View {
    @StateObject var myPageViewModel = DIContainer.shared.makeMyPageViewModel()
    @State private var showDetail: Bool = false
    @State private var showStudyStatus: Bool = false
    @State private var selectedIndex: Int = 0 // For MyStudyStatusView, 1 = Ongoing, 2 = Finished
    
    @State private var settinglistVO = ServiceInfo.MypageSettingList()
    
    private func loadData() {
        myPageViewModel.getProfileInfo()
        myPageViewModel.getOngoingStudyInfo()
        myPageViewModel.getFinishedStudyInfo()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if myPageViewModel.profileData == nil {
                ProgressView()
            } else {
                VStack(spacing: 0) {
                    MypageProfileView.padding(.top, 26)
                    MypageStudyView.padding(.top, 24)
                    ServiceInfoListView.padding(.top, 28)
                }
                .containerRelativeFrame([.horizontal, .vertical])
                .background(.gray1)
            }
        }
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
        .backButtonStyle()
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
            loadData()
        }
    }
    
    // MARK: MypageProfileView
    var MypageProfileView: some View {
        HStack(spacing: 0) {
            LoadableImageView(imageUrl: myPageViewModel.profileData?.profileImageUrl, size: 80)
                .radiusBorder(cornerRadius: 40, color: .gray3)
                .padding(.leading, 26)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(myPageViewModel.profileData?.userName ?? "이름없음" )
                        .font(.bbip(.title3_m20))
                        .foregroundStyle(.mainBlack)
                        .padding(.trailing, 17)
                    
                    Text(myPageViewModel.parsedOccupation)
                        .font(.bbip(.caption3_r12))
                        .foregroundStyle(.gray7)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, 10)
                
                HStack(spacing: 5) {
                    ForEach(myPageViewModel.parsedInterests.prefix(3), id: \.self) { interest in
                        CapsuleView(title: interest, type: .normal)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
            }
            Spacer()
            
            Button {
                showDetail = true
            } label: {
                Image("info_open")
                    .padding(.trailing,28)
            }
        }
        .navigationDestination(isPresented: $showDetail) {
            ProfileDetailView(
                viewModel: myPageViewModel,
                userName: myPageViewModel.profileData?.userName ?? "Unknown",
                profileImageUrl: myPageViewModel.profileData?.profileImageUrl ?? "profile_default",
                parsedArea: myPageViewModel.parsedArea,
                parsedOccupation: myPageViewModel.parsedOccupation,
                parsedInterests: myPageViewModel.parsedInterests,
                birthYear: myPageViewModel.profileData?.birthYear ?? "0000"
            )
        }
    }
    
    // MARK: MypageStudyView
    var MypageStudyView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("나의 스터디")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                
                Spacer()
            }
            .padding(.leading, 28)
            
            HStack(spacing: 11) {
                MyStudyDetailButton(
                    title: "진행 중인 스터디",
                    count: myPageViewModel.ongoingStudyCount,
                    iconName: "mypage_punch",
                    action: {
                        selectedIndex = 0
                        showStudyStatus = true
                    }
                )
                
                MyStudyDetailButton(
                    title: "종료된 스터디",
                    count: myPageViewModel.finishedStudyCount,
                    iconName: "mypage_belt",
                    action: {
                        selectedIndex = 1
                        showStudyStatus = true
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationDestination(isPresented: $showStudyStatus) {
            MyStudyStatusView(initialIndex: selectedIndex, viewModel: myPageViewModel)
        }
    }
    
    // MARK: ServiceInfoListView
    var ServiceInfoListView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.mainWhite)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ForEach(settinglistVO) { data in
                    ServiceInfoListRow(data: data)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 20)
                }
                
                Spacer()
                
                Text("@BBIP")
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray5)
                    .padding(.bottom, 64)
            }
            .padding(.top, 28)
        }
    }
}

fileprivate struct MyStudyDetailButton: View {
    private let title: String
    private let count: Int
    private let iconName: String
    private let action: () -> Void
    
    init(
        title: String,
        count: Int,
        iconName: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.count = count
        self.iconName = iconName
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.mainWhite)
                    .frame(maxHeight: 64)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.bbip(.caption2_m12))
                            .foregroundStyle(.gray7)
                            .lineLimit(1)
                        
                        HStack(spacing: 0) {
                            Text("\(count)")
                                .font(.bbip(.body1_sb16))
                                .foregroundStyle(.primary3)
                            
                            Text("개")
                                .font(.bbip(.body1_sb16))
                                .foregroundStyle(.gray8)
                        }
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    Image(iconName)
                }
                .padding(.horizontal, 19)
            }
        }
    }
}
