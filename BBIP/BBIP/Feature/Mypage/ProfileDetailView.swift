import Foundation
import SwiftUI

struct ProfileDetailView: View {
    private let imageSize: CGFloat = 124
    // `ProfileInfoList`를 State 변수로 초기화합니다.
    @State private var profileinfolist: [ProfileInfoList]
    
    var userName: String
    var profileImageUrl: String
    var parsedArea: String
    var parsedOccupation: String
    var parsedInterests: [String]
    var birthYear: String
    
    init(userName: String, profileImageUrl: String, parsedArea: String, birthYear:String, parsedOccupation: String, parsedInterests: [String]) {
        self.userName = userName
        self.profileImageUrl = profileImageUrl
        self.parsedArea = parsedArea
        self.parsedOccupation = parsedOccupation
        self.parsedInterests = parsedInterests
        self.birthYear = birthYear
        
        // 관심사를 콤마로 구분된 문자열로 변환합니다.
        let interestsString = parsedInterests.joined(separator: ", ")
        
        // `ProfileInfoList`를 동적으로 생성합니다.
        _profileinfolist = State(initialValue: [
            ProfileInfoList(infoType: "관심분야", infoName: interestsString),
            ProfileInfoList(infoType: "출생연도", infoName: birthYear),
            ProfileInfoList(infoType: "직업", infoName: parsedOccupation),
            ProfileInfoList(infoType: "지역", infoName: parsedArea)
        ])
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                // Image selection logic
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    LoadableImageView(imageUrl: profileImageUrl, size: imageSize)

                    Image("mypage_profile_edit")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16.5)
                }
                .padding(.top, 30)
            }

            Text(userName)
                .font(.bbip(.title3_m20))
                .foregroundStyle(.mainBlack)
                .padding(.top, 20)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("기본정보")
                        .font(.bbip(.body1_b16))
                        .foregroundStyle(.gray8)

                    Spacer()
                }
                .padding(.leading, 28)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray3, lineWidth: 1) // 테두리 색상과 두께 설정
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainWhite))
                        .frame(maxWidth: .infinity)
                        .frame(height: 65)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                    HStack(spacing: 0) {
                        Text("소셜 로그인")
                            .font(.bbip(.body1_m16))
                            .foregroundStyle(.gray7)
                            .padding(.leading, 16)

                        Text("APPLE")
                            .font(.bbip(.body2_m14))
                            .foregroundStyle(.gray9)
                            .padding(.leading, 21)

                        Spacer()
                    }
                    .padding(.leading, 16)
                }
                .padding(.top, 12)
            }
            .padding(.top, 23)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("부가정보")
                        .font(.bbip(.body1_b16))
                        .foregroundStyle(.gray8)

                    Spacer()
                }
                .padding(.leading, 28)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray3, lineWidth: 1) // 테두리 색상과 두께 설정
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainWhite))
                        .frame(maxWidth: .infinity)
                        .frame(height: 179)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                    VStack(spacing: 0) {
                        Spacer().frame(height: 24)

                        ForEach(profileinfolist) { profileinfolist in
                            ProfileInfoListRow(profileinfolist: profileinfolist)
                                .padding(.leading, 16)
                                .padding(.trailing, 26)
                                .padding(.bottom, 21)
                        }
                    }
                }
                .padding(.top, 12)
            }
            .padding(.top, 21)

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray3, lineWidth: 1) // 테두리 색상과 두께 설정
                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainWhite))
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding(.leading, 137)
                    .padding(.trailing, 137)

                Text("BBIP 탈퇴하기")
                    .font(.bbip(.button2_m16))
                    .foregroundStyle(.gray7)
            }
            .padding(.bottom, 64)
        }
        .navigationBarTitleDisplayMode(.inline)
        .backButtonStyle()
        .navigationTitle("내 정보 관리")
        .background(.gray1)
    }
}
