//
//  CreateCodeDoneView.swift
//  BBIP
//
//  Created by 조예린 on 9/28/24.
//

import Foundation
import SwiftUI
import Combine

struct CreateCodeDoneView: View{
    @EnvironmentObject private var appState: AppStateManager
    @Binding var attendCode : String
    @Binding var remainingTime : Int
    @State private var formattedTime: String = "00:00"
    @State private var timer: AnyCancellable?
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        if timer == nil {
            formattedTime = formatTime(remainingTime)
            
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    guard remainingTime > 0 else {
                        timer?.cancel()
                        timer = nil // 타이머가 종료되었으므로 nil로 설정
                        return
                    }
                    remainingTime -= 1
                    formattedTime = formatTime(remainingTime)
                }
        }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    
    var body: some View{
        VStack(spacing:0){
            Text("출석 인증을 시작합니다.")
                .font(.bbip(.title4_sb24))
                .foregroundStyle(.mainWhite)
                .padding(.top,101)
            
            Text("코드 번호를 팀원에게 알려주세요")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
                .padding(.top,12)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.gray8)
                    .padding(.horizontal, 38)
                
                HStack(spacing: 15) {
                    Image("alarm")
                        .renderingMode(.template)
                        .foregroundColor(remainingTime == 0 ? .primary3 : .mainWhite)
                    
                    Text(formattedTime)
                        .font(.bbip(.title1_sb42))
                        .foregroundStyle(remainingTime == 0 ? .primary3 : .mainWhite)
                        .onAppear {
                            startTimer()
                        }
                        .onDisappear {
                            stopTimer()
                        }
                }
            }
            .padding(.top,34)
            
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .frame(height:30)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,117)
                    .foregroundStyle(.gray8)
                
                HStack(spacing:9){
                    Text("인증코드: ")
                        .font(.bbip(.caption1_m16))
                        .foregroundStyle(.gray4)
                    
                    Text(attendCode)
                        .font(.bbip(.caption1_m16))
                        .foregroundStyle(.gray4)
                }
            }
            .padding(.top,21)
            
            Spacer()
            
            MainButton(text:"홈으로 가기", enable: true){
                appState.popToRoot()
            }
            .padding(.bottom,22)
        }
        .backButtonStyle(isReversal: false)
        .background(.gray9)
        
    }
}
