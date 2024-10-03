import Foundation
import SwiftUI

struct ProfileInfoList : Identifiable, Hashable{
    var id = UUID()
    var infoType: String
    var infoName: String
    var iconName = "수정"
    
    static func InfoList() -> [ProfileInfoList] {
        return [
            ProfileInfoList(infoType: "관심분야", infoName: "디자인,전공과목,기타"),
            ProfileInfoList(infoType: "출생연도", infoName: "2003"),
            ProfileInfoList(infoType: "직업", infoName: "대학생"),
            ProfileInfoList(infoType: "지역", infoName: "경기도 수원시 영통구")
        ]
    }
}


struct ProfileInfoListRow : View{
    let profileinfolist : ProfileInfoList
    
    var infotypelen: Int {
            return profileinfolist.infoType.count
        }
    
    var paddingSize: CGFloat {
            if infotypelen == 4 {
                return 35
            } else {
                return 63
            }
        }
    
    var body: some View{
        HStack(spacing:0){
            Text(profileinfolist.infoType)
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray7)
                .padding(.leading,16)
            
            Text(profileinfolist.infoName)
                .font(.bbip(.body2_m14))
                .foregroundStyle(.gray9)
                .padding(.leading,paddingSize)
            
            Spacer()
            
            Button{
                
            }label: {
                Text(profileinfolist.iconName)
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray5)
                    .padding(.trailing,16)
            }
            
        }
    }
    
}
