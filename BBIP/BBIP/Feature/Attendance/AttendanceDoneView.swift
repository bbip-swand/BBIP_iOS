//
//  AttendanceDoneView.swift
//  BBIP
//
//  Created by 조예린 on 9/15/24.
//

import SwiftUI

struct AttendanceDoneView: View{
    @EnvironmentObject  var appState: AppStateManager
    
    var body : some View{
        VStack(spacing:0){
            Text("라운드 준비 완료!")
                .font(.bbip(family: .SemiBold, size: 24))
                .foregroundStyle(.mainWhite)
                .padding(.top,72)
                .padding(.bottom,8)
            
            Text("출석이 성공적으로 완료되었습니다.")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
            
            Spacer()
            
            BBIPLottieView(assetName: "CodeCheck", withBackground: false)
            
            Spacer()
            
            MainButton(text: "돌아가기", enable:true) {
                appState.popToRoot() 
            }
            .padding(.bottom, 22)
        }
        .backButtonStyle(isReversal: false)
        .background(.gray9)
        
    }
}
