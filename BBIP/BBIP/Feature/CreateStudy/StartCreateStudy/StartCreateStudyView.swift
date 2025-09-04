//
//  StartCreateStudyView.swift
//  BBIP
//
//  Created by 이건우 on 8/29/24.
//

import SwiftUI
import LinkNavigator

struct StartCreateStudyView: View {
    let navigator: LinkNavigatorType
    
    @State private var showStudyInfoSetupView: Bool = false
    @State private var offset: CGSize = .zero
    @State private var angle: Double = 0
    @State private var isAnimating: Bool = false
    
    private func startAnimation() {
        isAnimating = true
        let offsetRatio = (UIScreen.main.bounds.width / 26)
        
        // offset animation
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            offset = CGSize(width: offsetRatio, height: offsetRatio)
        }
        
        // angle animation
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            angle = 10
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Group {
                Text("팀원들과 함께 경기할")
                    .padding(.top, 73)
                Text("스터디그룹을 생성해보세요")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.bbip(.title4_sb24))
            .foregroundStyle(.mainWhite)
            .padding(.leading, 20)
            
            Text("간편하게 생성하고, 팀원을 초대할 수 있습니다")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .padding(.leading, 20)
            
            Spacer()
            
            Image("start_createStudy1")
                .overlay(
                    Image("glassess")
                        .offset(offset)
                        .rotationEffect(.degrees(angle))
                        .padding(.leading, 40)
                        .padding(.bottom, 28),
                    alignment: .bottomLeading
                )
                .padding(.bottom, 32)
                .onAppear {
                    startAnimation()
                }
            
            MainButton(text: "시작하기") {
                if navigator.currentPaths.last == BBIPMatchPath.startCreateStudy.capitalizedPath {
                    navigator.next(paths: [BBIPMatchPath.studyInfoSetup.capitalizedPath], items: [:], isAnimated: true)
                } else {
                    showStudyInfoSetupView = true
                }
            }
            .padding(.bottom, 22)
        }
        .toolbar(.visible, for: .navigationBar)
        .containerRelativeFrame([.horizontal, .vertical])
        .backButtonStyle(isReversal: true)
        .background(.gray9)
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray9)
        }
        .navigationDestination(isPresented: $showStudyInfoSetupView) {
            // LN TODO: 삭제 예정
            StudyInfoSetupView(navigator: navigator)
        }
    }
}
