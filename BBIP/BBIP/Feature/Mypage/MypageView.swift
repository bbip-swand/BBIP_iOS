//
//  MypageView.swift
//  BBIP
//
//  Created by 이건우 on 9/9/24.
//

import SwiftUI

struct MypageView: View {
    @StateObject var mypageviewModel = DIContainer.shared.makeMypageDetailViewModel()
    @State var userInfodata: UserInfoVO?
    @State private var showDetail:Bool = false
    @State private var showStudying : Bool = false
    @State private var showStudied : Bool = false
    @State private var settinglist = SettingList.MypageSettingList()
    @State var ongoingStudyCount: Int = 0
    @State var finishedStudyCount: Int = 0
    
    
    
    init() {
        setNavigationBarAppearance()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if mypageviewModel.profileData == nil {
                // 데이터가 로드되기 전, 흰색 뷰를 표시
                Color.white
                    .ignoresSafeArea()
            } else {
                // 데이터가 로드된 후 실제 뷰 표시
                VStack(spacing: 0) {
                    MypageProfileView.padding(.top, 26)
                    MypageStudyView.padding(.top, 24)
                    MypageSettingListView
                }
                .containerRelativeFrame([.horizontal, .vertical])
                .background(.gray1)
                .navigationTitle("마이페이지")
                .navigationBarTitleDisplayMode(.inline)
                .backButtonStyle()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadData()
        }
    }
    //MARK: MypageProfileView
    var MypageProfileView: some View {
        HStack (spacing: 0){
            LoadableImageView(imageUrl: mypageviewModel.profileData?.profileImageUrl, size: 80)
                .padding(.leading, 26)
            
            VStack(spacing:0){
                HStack(spacing:0){
                    Text(mypageviewModel.profileData?.userName ?? "이름없음" )
                        .font(.bbip(.title3_m20))
                        .foregroundStyle(.mainBlack)
                        .padding(.trailing,17)
                    
                    Text(mypageviewModel.parsedOccupation)
                        .font(.bbip(.caption3_r12))
                        .foregroundStyle(.gray7)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, 10)
                
                HStack(spacing:5){
                    ForEach(mypageviewModel.parsedInterests.prefix(3), id: \.self) { interest in
                        let textWidth = textWidth(for: interest, font: UIFont.systemFont(ofSize: 12))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray8)
                                .frame(width: textWidth + 16, height: 24) // 텍스트의 너비 + 좌우 여백 8씩 총 16
                            
                            Text(interest)
                                .font(.bbip(.caption2_m12))
                                .foregroundStyle(.gray8)
                                .padding(.horizontal, 8) // 좌우 여백 8
                        }
                    }
                    Spacer()
                    
                }
                .padding(.leading, 20)
            }
            Spacer()
            
            Button{
                showDetail = true
            }label: {
                Image("info_open")
                    .padding(.trailing,28)
            }
        }
        .navigationDestination(isPresented: $showDetail){
            ProfileDetailView(
                userName: mypageviewModel.profileData?.userName ?? "티니핑",
                profileImageUrl: mypageviewModel.profileData?.profileImageUrl ?? "profile_default",
                parsedArea: mypageviewModel.parsedArea,
                birthYear: mypageviewModel.profileData?.birthYear ?? "0000",
                parsedOccupation: mypageviewModel.parsedOccupation,
                parsedInterests: mypageviewModel.parsedInterests
            )
        }
    }
    
    //MARK: MypageStudyView
    var MypageStudyView:  some View {
        VStack(spacing: 0) {
            HStack(spacing:0){
                Text("나의 스터디")
                    .font(.bbip(.body1_b16))
                    .foregroundStyle(.gray8)
                
                Spacer()
            }
            .padding(.leading,28)
            
            HStack(spacing:11){
                
                Button{
                    showStudying = true
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.mainWhite)
                            .frame(maxWidth: .infinity, maxHeight: 64)
                            .padding(.leading, 16)
                        
                        HStack(spacing:0){
                            VStack(alignment:.leading,spacing:0){
                                Text("진행 중인 스터디")
                                    .font(.bbip(.body2_m14))
                                    .foregroundStyle(.gray7)
                                
                                HStack(spacing:0){
                                    Text("\(ongoingStudyCount)")
                                        .font(.bbip(.body1_sb16))
                                        .foregroundStyle(.primary3)
                                        .padding(.top, 4)
                                    
                                    Text("개")
                                        .font(.bbip(.body1_sb16))
                                        .foregroundStyle(.gray8)
                                        .padding(.top, 4)
                                    
                                }
                            }
                            
                            Spacer()
                            
                            Image("mypage_punch")
                                .resizable()
                                .frame(width:35, height: 35)
                        }
                        .padding(.leading,35)
                        .padding(.trailing,19)
                        
                    }
                }
                
                Button{
                    showStudied = true
                }label:{
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.mainWhite)
                            .frame(maxWidth: .infinity, maxHeight: 64)
                            .padding(.trailing,16)
                        
                        HStack(spacing:0){
                            VStack(alignment:.leading,spacing:0){
                                Text("종료된 스터디")
                                    .font(.bbip(.body2_m14))
                                    .foregroundStyle(.gray7)
                                
                                HStack(spacing:0){
                                    Text("\(finishedStudyCount)")
                                        .font(.bbip(.body1_sb16))
                                        .foregroundStyle(.primary3)
                                        .padding(.top, 4)
                                    
                                    Text("개")
                                        .font(.bbip(.body1_sb16))
                                        .foregroundStyle(.gray8)
                                        .padding(.top, 4)
                                    
                                }
                            }
                            
                            Spacer()
                            
                            Image("mypage_belt")
                                .resizable()
                                .frame(width:35, height: 24.05)
                        }
                        .padding(.leading, 19)
                        .padding(.trailing,31)
                    }
                }
                
                
            }
            .padding(.top,12)
        }
        .navigationDestination(isPresented: $showStudying) {
            StudySetView(initialIndex: 0) // 진행 중인 스터디로 초기화
        }
        .navigationDestination(isPresented: $showStudied) {
            StudySetView(initialIndex: 1) // 종료된 스터디로 초기화
        }
    }
    
    
    
    //MARK: MypageSettingListView
    var MypageSettingListView: some View{
        ZStack {
            Rectangle()
                .foregroundColor(.mainWhite)
                .padding(.top,29)
                .ignoresSafeArea()
            
            VStack(spacing:0){
                
                Spacer().frame(height:28)
                
                //TODO: 나중에 스크롤 처리
                ForEach(settinglist){ settinglist in
                    SettingListRow(settinglist: settinglist)
                        .listRowInsets(EdgeInsets())
                        .padding(.leading,28)
                        .padding(.trailing,28)
                        .padding(.bottom,15)
                }
                
                Spacer()
                
                Text("@BBIP")
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray5)
                    .padding(.bottom,64)
                
            }
            .padding(.top,29)
        }
        
    }
    
    private func textWidth(for text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
    // MARK: Load Data Function
    private func loadData() {
        mypageviewModel.getProfileInfo()
        mypageviewModel.getOngoingStudyInfo()
        mypageviewModel.getFinishedStudyInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ongoingStudyCount = mypageviewModel.ongoingStudyCount
            finishedStudyCount = mypageviewModel.finishedStudyCount
            
            print("유저 userInfo데이터: \(mypageviewModel.profileData)")
        }
    }
    
}
