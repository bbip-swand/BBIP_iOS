//
//  JoinStudyCompleteAlert.swift
//  BBIP
//
//  Created by 이건우 on 10/3/24.
//

import SwiftUI

struct JoinStudyCompleteAlert: View {
    var body: some View {
        ZStack() {
            Color.mainBlack.opacity(0.8)
            
            VStack(spacing: 26) {
                Image("joinStudy_complete")
                    .resizable()
                    .frame(width: 140, height: 140)
                
                Text("참여에 성공했어요!")
                    .font(.bbip(.title1_sb28))
                    .foregroundStyle(.mainWhite)
            }
        }
        .ignoresSafeArea(.all)
        .containerRelativeFrame([.horizontal, .vertical])
    }
}
