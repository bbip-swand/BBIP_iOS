//
//  StartGuideView.swift
//  BBIP
//
//  Created by 이건우 on 10/2/24.
//

import SwiftUI
import LinkNavigator

struct StartGuideView: View {
    let navigator: LinkNavigatorType
    @State private var showCreateStudyView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Group {
                Text("스터디 팀장이 되어")
                Text("삡과 함께 시작해보세요!")
                    .padding(.bottom, 12)
            }
            .font(.bbip(.title4_sb24))
            .foregroundStyle(.mainBlack)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            Text("새로운 스터디를 생성하고 팀원을 초대하세요")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 22)
            
            Image("startGuide")
                .padding(.bottom, 35)
            
            Group {
                Text("*스터디에 참여하고 싶다면?")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray7)
                    .padding(.bottom, 4)
                
                Text("팀장에게 받은 초대 링크로 스터디에 참여하세요")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray6)
                    .padding(.bottom, 20)
            }
            
            Button {
                showCreateStudyView = true
            } label: {
                Text("생성하기")
                    .font(.bbip(.button1_m20))
                    .foregroundColor(.mainWhite)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 56)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.primary3))
            }
            .padding(.bottom, 22)
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.gray1)
        .navigationDestination(isPresented: $showCreateStudyView) {
            StartCreateStudyView()
        }
    }
}
