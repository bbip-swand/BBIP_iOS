import Foundation
import SwiftUI
import Combine

struct AttendRecordView: View {
    @EnvironmentObject var attendviewModel: AttendanceCertificationViewModel
    @State private var formattedTime: String = "00:00"
    @Binding var remainingTime: Int
    var code: Int?
    @State private var timer: AnyCancellable?

    @State private var isRefresh: Bool = false
    private var completion: (() -> Void)?
    
     
    init(
        remainingTime: Binding<Int>,
        code: Int?,
        completion: (() -> Void)? = nil
    ) {
        self._remainingTime = remainingTime
        self.code = code
        self.completion = completion
        setNavigationBarAppearance(forDarkView: true)
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
                formattedTime = formatTime(remainingTime)
            }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.gray8)
                        
                        HStack(spacing: 9) {
                            Image("alarm")
                                .resizable()
                                .frame(width: 21, height: 21)
                                .foregroundColor(.mainWhite)
                            
                            Text("남은 시간:")
                                .font(.bbip(.body1_sb16))
                                .foregroundStyle(.mainWhite)
                            
                            Text(formattedTime)
                                .font(.bbip(.caption1_m16))
                                .foregroundStyle(.mainWhite)
                        }
                    }
                    Spacer().frame(width: 19)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 30)
                            .frame(width: 149)
                            .foregroundStyle(.gray8)
                        
                        HStack(spacing: 9) {
                            Text("인증코드:")
                                .font(.bbip(.caption1_m16))
                                .foregroundStyle(.mainWhite)
                            
//                            Text(String(code))
//                                .font(.bbip(.caption1_m16))
//                                .foregroundStyle(.mainWhite)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 23)
                
                Text("경기 참여")
                    .font(.bbip(.body1_sb16))
                    .foregroundStyle(.mainWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 28)
                    .padding(.leading, 26)
                    .padding(.bottom, 12)
                
                // 경기참가한 사람들의 studyEntryCard 필요
                ForEach(0..<attendviewModel.records.filter { $0.status == .attended }.count, id: \.self) { index in
                    let record = attendviewModel.records.filter { $0.status == .attended }[index]
                    studyEntryCard(vo: record)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
                
                Text("경기 미참여")
                    .font(.bbip(.body1_sb16))
                    .foregroundStyle(.mainWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                    .padding(.leading, 26)
                
                Text("아직 인증하지 않은 팀원에게 연락해보세요")
                    .font(.bbip(.caption2_m12))
                    .foregroundStyle(.gray6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 6)
                    .padding(.leading, 26)
                    .padding(.bottom, 12)
                
                
                // 경기 미참여한 사람들의 studyEntryCard 필요
                ForEach(0..<attendviewModel.records.filter { $0.status == .absent }.count, id: \.self) {index in
                    let record = attendviewModel.records.filter { $0.status == .absent }[index]
                    studyEntryCard(vo: record)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
                
            }
        }
        .backButtonStyle(isReversal: true)
        .navigationTitle("출결 현황")
        .navigationBarTitleDisplayMode(.inline)
        .background(.gray9)
        .onAppear {
//            attendviewModel.getAttendRecord(studyId: studyId)
            startTimer()
        }
        .onDisappear {
            timer?.cancel()
        }
        .refreshable {
//            attendviewModel.getAttendRecord(studyId: studyId)
            isRefresh = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { isRefresh = false }
            }
        }
        .scrollIndicators(.never)
        .introspect(.scrollView, on: .iOS(.v17, .v18)) { scrollView in
            scrollView.backgroundColor = .gray9
            scrollView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            scrollView.refreshControl?.tintColor = .primary3
        }
    }
}

struct studyEntryCard: View {
    private let vo: getAttendRecordVO
    
    init(vo: getAttendRecordVO) {
        self.vo = vo
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 68)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.gray8)
            
            HStack(spacing: 0) {
                LoadableImageView(imageUrl: vo.profileImageUrl, size: 48)
                    .padding(.trailing, 19)
                
                Text(vo.userName)
                    .font(.bbip(.body1_sb16))
                    .foregroundStyle(.mainWhite)
                
                Spacer()
            }
            .padding(.horizontal, 14)
        }
    }
}
