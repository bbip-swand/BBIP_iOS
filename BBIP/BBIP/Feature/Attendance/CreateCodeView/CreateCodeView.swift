//
//  CreateCodeView.swift
//  BBIP
//
//  Created by 조예린 on 9/28/24.
//

import Foundation
import SwiftUI
import Combine

struct CreateCodeView: View{
    //TODO: vo로 받은 코드 String 변환 작업 해야함
    @StateObject var viewModel = DIContainer.shared.createAttendCodeViewModel()
    @State var startAttend: Bool = false
    @State var attendCode: String
    @State var remainingTime: Int = 600
    @State private var timer: AnyCancellable?
    
    
    private func startTimer() {
        if timer == nil {
            
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    guard remainingTime > 0 else {
                        timer?.cancel()
                        timer = nil // 타이머가 종료되었으므로 nil로 설정
                        return
                    }
                    remainingTime -= 1
                }
        }
        print("remainingTime: \(remainingTime)")
    }
    
    var body: some View{
        VStack(spacing:0){
            Text("출석 인증 코드")
                .font(.bbip(.title4_sb24))
                .foregroundStyle(.mainWhite)
                .padding(.top,101)
            
            Text("아래 버튼을 눌러 출석 인증을 시작하세요")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
                .padding(.top,12)
            
            HStack(spacing:12){
                ForEach(attendCode.map{ String($0) }, id: \.self) { digit in
                    Text(digit)
                        .font(.bbip(.title1_sb42))
                        .foregroundColor(.mainWhite)
                        .frame(width: 70, height: 70)
                        .background(.gray8)
                        .cornerRadius(12)
                }
            }
            .padding(.top,34)
            .padding(.horizontal, 38)
            
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .frame(height:30)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,117)
                    .foregroundStyle(.gray8)
                
                HStack(spacing:9){
                    Image("alarm")
                        .resizable()
                        .frame(width: 21, height:21)
                        .foregroundColor(.gray4)
                    
                    Text("시간 제한: 10분")
                        .font(.bbip(.caption1_m16))
                        .foregroundStyle(.gray4)
                }
            }
            .padding(.top,21)
            
            Spacer()
            
            MainButton(text:"시작하기", enable: true){
                startAttend = true
                startTimer()
            }
            .padding(.bottom,22)
            
        }
        .backButtonStyle(isReversal: true)
        .background(.gray9)
        .navigationDestination(isPresented: $startAttend){
            CreateCodeDoneView(attendCode: $attendCode, remainingTime: $remainingTime)
        }
        .onAppear {
            print("Received attendCode: \(attendCode)")
        }
        
    }
}
