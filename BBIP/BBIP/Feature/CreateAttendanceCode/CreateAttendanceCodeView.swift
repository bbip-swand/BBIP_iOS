//
//  CreateCodeView.swift
//  BBIP
//
//  Created by 이건우 on 11/18/24.
//

import Factory
import SwiftUI
import Combine

struct CreateAttendanceCodeView: View {
    @EnvironmentObject var appState: AppStateManager
    @Injected(\.createAttendanceCodeViewModel) var viewModel
    @State private var timer: AnyCancellable?
    
    @State private var formattedTime: String = "10:00"
    @State private var remainingTime: Int = 600
    
    private let studyId: String
    private let session: Int
    
    init(
        studyId: String,
        session: Int
    ) {
        self.studyId = studyId
        self.session = session
    }
    
    private func startTimer() {
        formattedTime = formatTime(remainingTime)
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { _ in
                guard remainingTime > 0 else {
                    timer?.cancel()
                    return
                }
                remainingTime -= 1
                formattedTime = formatTime(remainingTime)
            }
    }
    
    private func cancelTimer() {
        timer?.cancel()
    }
    
    /// "MM:SS" 형식으로 format
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("출석 인증을 시작합니다")
                .font(.bbip(.title4_sb24))
                .foregroundStyle(.mainWhite)
                .padding(.top, 101)
            
            Text("코드 번호를 팀원에게 알려주세요")
                .font(.bbip(.caption1_m16))
                .foregroundStyle(.gray6)
                .padding(.top, 12)
            
            HStack(spacing: 12) {
                if let code = viewModel.attendanceCode {
                    ForEach(code.map{ String($0) }, id: \.self) { digit in
                        Text(digit)
                            .font(.bbip(.title1_sb42))
                            .foregroundColor(.mainWhite)
                            .frame(width: 70, height: 70)
                            .background(.gray8)
                            .cornerRadius(12)
                    }
                } else {
                    ForEach(0...3, id: \.self) { digit in
                        Text("-")
                            .font(.bbip(.title1_sb42))
                            .foregroundColor(.mainWhite)
                            .frame(width: 70, height: 70)
                            .background(.gray8)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.top, 34)
            .padding(.horizontal, 38)
            
            HStack(spacing: 9) {
                Image("alarm")
                    .resizable()
                    .frame(width: 21, height: 21)
                    .foregroundColor(.gray4)
                
                Text("남은 시간 : \(formattedTime)")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray4)
            }
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 30)
                    .foregroundStyle(.gray8)
            )
            .padding(.top, 21)
            
            Spacer()
            
            MainButton(text: "홈으로 가기", enable: true) {
                appState.popToRoot()
            }
            .padding(.bottom, 22)
        }
        .backButtonStyle(isReversal: true)
        .containerRelativeFrame(.horizontal)
        .background(.gray9)
        .onAppear {
            viewModel.createAttendanceCode(studyId: studyId, session: session) {
                startTimer()
            }
        }
        .onDisappear {
            cancelTimer()
        }
    }
}
