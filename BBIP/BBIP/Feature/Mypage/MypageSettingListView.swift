import Foundation
import SwiftUI

struct SettingList : Identifiable, Hashable {
    
    var setName: String
    var iconName:String = "info_open"
    let id = UUID()
    
    static func MypageSettingList()-> [SettingList]{
        return [SettingList(setName: "공지사항"),
                SettingList(setName: "약관 및 정책"),
                SettingList(setName: "버전 정보", iconName:"1.0.0"),
        ]
    }
    
}


struct SettingListRow : View{
    let settinglist : SettingList
    
    var body: some View{
        HStack(spacing:0){
            Text(settinglist.setName)
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray8)
            
            Spacer()
            
            if settinglist.iconName == "info_open"{
                //TODO: 추후버튼으로 교체
                Image(settinglist.iconName)
            }else{
                Text(settinglist.iconName)
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray6)
            }
            
        }
    }
    
}
