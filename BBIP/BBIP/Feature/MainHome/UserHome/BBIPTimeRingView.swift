//
//  BBIPTimeRingView.swift
//  BBIP
//
//  Created by 이건우 on 9/10/24.
//

import SwiftUI
import Combine

//TODO: remainingTime 받아오고 전역으로 관리하기 (활성화되었을때 타임링 시간 표시해주기)

struct BBIPTimeRingView: View {
    @State var startAttend: Bool = false
    @State private var progress: Double
    @EnvironmentObject var appState: AppStateManager
    private var vo: ImpendingStudyVO
    
    private var lineWidth: CGFloat = 8
    private var endCircleSize: CGFloat = 18
    
    init(
        progress: Double,
        vo: ImpendingStudyVO
    ) {
        self.progress = progress
        self.vo = vo
    }
    
    private var ddayLabel: String {
        vo.leftDay == .zero ? "TODAY" : "D-\(vo.leftDay)"
    }
    
    private var contentBody: some View {
        VStack(spacing: 0) {
            CapsuleView(title: ddayLabel, type: .timeRing)
                .padding(.bottom, 20)
            
            Text(vo.title)
                .font(.bbip(.title4_sb24))
                .foregroundStyle(.mainWhite)
                .padding(.bottom, 12)
            
            Group {
                Text(vo.time)
                    .padding(.bottom, 2)
                
                Text(vo.location ?? "장소 미정")
            }
            .font(.bbip(.body2_m14))
            .foregroundStyle(.gray5)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                let radius = (geometry.size.width - 18 * 2) / 2
                let angle = Angle(degrees: progress * 360 - 90)
                let xOffset = cos(angle.radians) * radius
                let yOffset = sin(angle.radians) * radius
                
                ZStack {
                    Circle()
                        .foregroundStyle(.gray8)
                    
                    Group {
                        Circle()
                            .stroke(
                                .gray6,
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                .primary3,
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear, value: progress)
                    }
                    .padding(18)
                    
                    Circle()
                        .foregroundStyle(.primary3)
                        .frame(width: endCircleSize, height: endCircleSize)
                        .offset(x: xOffset, y: yOffset)
                        .animation(.easeIn, value: progress)
                }
                .overlay {
                    contentBody
                    
                    Image("timeRingStick_disable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: 30, y: 62)
                        .unredacted()
                }
            }
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray3)
                .frame(width: 130, height: 43)
                .overlay {
                    Text("출석인증")
                        .font(.bbip(.body2_b14))
                        .foregroundStyle(.gray5)
                }
        }
        .frame(height: (UIScreen.main.bounds.width - 120) + 43 + 24)
        .padding(.horizontal, 60)
    }
}

struct ActivatedBBIPTimeRingView: View {
    @EnvironmentObject var attendviewModel: AttendanceCertificationViewModel
    @EnvironmentObject var appState: AppStateManager
    @State private var progress: Double = 0
    @Binding var remainingTime: Int
    @Binding var studyId: String
    @Binding var session: Int
    @State private var formattedTime: String = "00:00"
    @State private var timer: AnyCancellable?
    @State private var showCircle: Bool = false
    @State private var shakeStick: Bool = false
    @State private var showDisabled: Bool = false
    @State private var showAttendRecordView: Bool = false
    private let initialTime: Int = 600 // for test
    private var studyTitle: String
    private var lineWidth: CGFloat = 8
    private var endCircleSize: CGFloat = 18
    private var completion: (() -> Void)?
    @State var code: Int?
    
    
    init(
        studyTitle: String,
        remainingTime: Binding<Int>,
        studyId: Binding<String>,
        session: Binding<Int>,
        completion: (() -> Void)? = nil
    ) {
        self._studyId = studyId
        self._session = session
        self.studyTitle = studyTitle
        self._remainingTime = remainingTime
        self.completion = completion
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        formattedTime = formatTime(remainingTime)
        
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard remainingTime > 0 else {
                    timer?.cancel()
                    completion?()
                    return
                }
                remainingTime -= 1
                progress = Double(remainingTime) / Double(attendviewModel.getStatusData?.ttl ?? 600)
                formattedTime = formatTime(remainingTime)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if !showCircle { showCircle = true }
                }
            }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                let radius = (geometry.size.width - 18 * 2) / 2
                let angle = Angle(degrees: progress * 360 - 90)
                let xOffset = cos(angle.radians) * radius
                let yOffset = sin(angle.radians) * radius
                
                ZStack {
                    Circle()
                        .foregroundStyle(.primary3)
                    
                    Group {
                        Circle()
                            .stroke(
                                .primary2,
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                .mainWhite,
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeInOut(duration: 0.25), value: progress)
                    }
                    .padding(18)
                    
                    Circle()
                        .foregroundStyle(.mainWhite)
                        .frame(width: endCircleSize, height: endCircleSize)
                        .offset(x: xOffset, y: yOffset)
                        .opacity(showCircle ? 1 : 0)
                        .animation(.linear, value: showCircle)
                        .animation(.easeInOut, value: progress)
                }
                .overlay {
                    VStack(spacing: 5) {
                        Text(studyTitle)
                            .frame(maxWidth: 180)
                            .font(.bbip(.title3_m20))
                            .foregroundStyle(.mainWhite)
                            .lineLimit(1) // 한 줄로 제한
                            .truncationMode(.tail)
                        
                        Text(formattedTime)
                            .font(.bbip(.title1_sb42))
                            .foregroundStyle(.mainWhite)
                            .onAppear {
                                startTimer()
                            }
                    }
                }
                Image("timeRingStick_enable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 30, y: 62)
                    .unredacted()
            }
            
            Button {
//                print("isManager: \(String(describing: attendviewModel.getStatusData?.isManager))")
                print("isAttend: \(String(describing: attendviewModel.getStatusData?.status))")
               
                    print("isManager: \(String(describing: attendviewModel.getStatusData?.isManager))")
                
                if let isManager = attendviewModel.getStatusData?.isManager{
                    if isManager == true {
                        showAttendRecordView = true
                        
                    }else{ //팀원일때
                        if let isAttend = attendviewModel.getStatusData?.status{
                            if isAttend == true{
                                showDisabled = true
                            }else{
                                appState.push(.entercode)
                                showDisabled = true
                            }
                        }
                    }
                }
            } label: {
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(showDisabled ?  .gray3 : .primary3)
                    .frame(width: 130, height: 43)
                    .overlay {
                        Text("출석인증")
                            .font(.bbip(.body2_b14))
                            .foregroundStyle(showDisabled ?  .gray5 : .mainWhite)
                    }
            }
            .disabled(showDisabled)
            .buttonStyle(PlainButtonStyle())
            .background( // hide stick image
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.mainWhite)
                    .frame(width: 130, height: 43)
            )
        }
        .onAppear {
            // 출석 상태 데이터를 가져오는 함수 호출
            attendviewModel.getStatusAttend()
            code = attendviewModel.getStatusData?.code
            
            if let isAttend = attendviewModel.getStatusData?.status{
                if isAttend == true{
                    showDisabled = true
                }
            }
        }
        .onDisappear {
            timer?.cancel()
        }
        .frame(height: (UIScreen.main.bounds.width - 120) + 43 + 24)
        .padding(.horizontal, 60)
        .navigationDestination(isPresented: $showAttendRecordView) {
            
            AttendRecordView(remainingTime: $attendviewModel.remainingTime, code: code)
            
        }
        
    }
}


