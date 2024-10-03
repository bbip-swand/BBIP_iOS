//
//  CreateCodeView.swift
//  BBIP
//
//  Created by 조예린 on 9/28/24.
//

import Foundation
import SwiftUI
import Combine

//TODO: 스터디홈에서 여기로 넘어올때 출석 시간 끝났는지 안끝났는지 확인해줘야함.
//TODO: 스터디홈에서 remainingTime 남아있으면 출석현황 화면으로
struct CreateCodeOnboardingView: View{
    @StateObject private var viewModel = DIContainer.shared.createAttendCodeViewModel()
    @State var goNext = false
    @State var generatedCode: String = ""
    private let studyId: String
    private let session: Int
    
    init(studyId: String, session: Int) {
        self.studyId = studyId
        self.session = session
    }
    
    var body: some View{
        VStack(spacing:0){
            VStack(alignment:.leading, spacing:0){
                Text("오늘 경기에 참여하는\n팀원들의 출석 체크를 시작하세요")
                    .font(.bbip(.title4_sb24))
                    .foregroundStyle(.mainWhite)
                    .padding(.top,72)
                
                Text("출석 인증이 시작되면 팀원에게 알림이 가요")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray6)
                    .padding(.top,12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            
            Spacer()
            
            Image("create_code")
                .resizable()
                .frame(height: 186)
                .frame(maxWidth:.infinity)
                .padding(.horizontal,22)
                .padding(.bottom,97)
            
            MainButton(text: "코드 생성하기", enable: true){
                print("studyId: \(studyId)")
                print("session: \(session)")
                viewModel.createCode(attendVO: .init(studyId: studyId, session: session, code: 0))  // 코드 생성 호출
            }
            .padding(.bottom,22)
        }
        .backButtonStyle(isReversal: true)
        .background(.gray9)
        .onReceive(viewModel.$getCode) { code in
            if !code.isEmpty {
                self.generatedCode = code
                goNext = true
            }
        }
        .navigationDestination(isPresented: $goNext){
            CreateCodeView(attendCode:generatedCode)
        }
    }
}


