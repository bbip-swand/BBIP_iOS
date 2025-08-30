import SwiftUI
import Factory
import LinkNavigator

/// 삭제 alert 표시 정보
enum StudyDetailAlertType {
    case deleteConfirmation
    case deleteCompleted
    
    var message: String {
        switch self {
            case .deleteConfirmation: return "해당 글을 삭제하시겠습니까?"
            case .deleteCompleted: return "삭제된 글은 복구가 불가능합니다.\n글을 삭제 하시겠습니까?"
        }
    }
    
    var buttonText: String {
        switch self {
            case .deleteConfirmation: return "삭제"
            case .deleteCompleted: return "확인"
        }
    }
    
    var buttonTextColor: Color {
        switch self {
            case .deleteConfirmation: return .primary3
            case .deleteCompleted: return .green1
        }
    }
}

struct StudyDetailView: View {
    let navigator: LinkNavigatorType
    @EnvironmentObject private var appState: AppStateManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: StudyDetailViewModel
    
    // simple task
    private let dataSource = StudyDataSource()
    
    init(vo: FullStudyInfoVO, navigator: LinkNavigatorType) {
        _viewModel = StateObject(wrappedValue:Container.shared.studyDetailViewModel(vo)())
        self.navigator = navigator
    }
    
    var body: some View {
        VStack(spacing: 0) {
            studyImageSection
            studyInfoSection
            studyDetailsSection
            Spacer()
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.gray1)
        .navigationTitle("스터디 정보")
        .navigationBarTitleDisplayMode(.inline).toolbar{
            if viewModel.fullStudyInfo.isManager {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // 정보 수정 메뉴
                        Button {
                            viewModel.showStudyEditView = true
                        } label: {
                            Text("스터디 정보 수정")
                                .font(.bbip(.body2_m14))
                        }
                        
                        // 삭제 메뉴
                        Button {
                            viewModel.alertType = .deleteConfirmation
                            viewModel.deleteAlertIsPresented = true
                        } label: {
                            Text("스터디 삭제")
                                .font(.bbip(.body2_m14))
                        }
                    } label: {
                        Image("setting_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .backButtonStyle()
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
        }
        .customAlert(
            isPresented: $viewModel.deleteAlertIsPresented,
            message: viewModel.alertType.message,
            confirmText: viewModel.alertType.buttonText,
            confirmColor: viewModel.alertType.buttonTextColor
        ) {
            viewModel.alertButtonAction()
        }
        .navigationDestination(isPresented: $viewModel.showStudyEditView) {
            StudyInfoSetupView(type: .edit(viewModel.fullStudyInfo), navigator: navigator)
                .onDisappear {
                    viewModel.requestFullStudyInfo()
                }
        }
        .onReceive(viewModel.deleteSuccessSubject) {
            // 스터디 삭제 된 경우 실행
            appState.mainHomeSelectedTab = .userHome
            dismiss()
        }
    }
}


private extension StudyDetailView {
    // MARK: - Study Image Section
    var studyImageSection: some View {
        VStack(spacing: 0) {
            LoadableImageView(imageUrl: viewModel.fullStudyInfo.studyImageURL, size: 124)
                .overlay(
                    Circle().stroke(Color.gray5, lineWidth: 1)
                )
                .padding(.top, 30)
                .padding(.bottom, 20)
            
            Text(viewModel.fullStudyInfo.studyName)
                .font(.bbip(family: .Bold, size: 20))
                .padding(.bottom, 30)
        }
    }

    // MARK: - Study Info Section (Description)
    var studyInfoSection: some View {
        VStack(spacing: 12) {
            SectionHeaderView(title: "한줄 소개")
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
                .frame(height: 90)
                .bbipShadow1()
                .overlay(alignment: .topLeading) {
                    Text(viewModel.fullStudyInfo.studyDescription)
                        .font(.bbip(.body2_m14))
                        .padding(.top, 12)
                        .padding(.horizontal, 14)
                }
                .padding(.horizontal, 17)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Study Details Section
    var studyDetailsSection: some View {
        VStack(spacing: 12) {
            SectionHeaderView(title: "세부 정보")
            VStack(spacing: 20) {
                StudyDetailRowView(label: "분야", value: viewModel.fullStudyInfo.studyField.rawValue)
                StudyDetailRowView(label: "주차", value: "\(viewModel.fullStudyInfo.totalWeeks)주차", additionalValue: viewModel.fullStudyInfo.studyPeriodString)
                StudyDayTimeRow(daysOfWeek: viewModel.fullStudyInfo.daysOfWeek, studyTimes: viewModel.fullStudyInfo.studyTimes)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.mainWhite)
                    .bbipShadow1()
            )
            .padding(.horizontal, 17)
        }
    }
}

// MARK: - Section Header View
struct SectionHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.bbip(.body1_b16))
                .padding(.leading, 28)
            Spacer()
        }
    }
}

// MARK: - Study Detail Row View
struct StudyDetailRowView: View {
    let label: String
    let value: String
    let additionalValue: String?

    init(label: String, value: String, additionalValue: String? = nil) {
        self.label = label
        self.value = value
        self.additionalValue = additionalValue
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray7)
                .padding(.trailing, 63)
            
            Text(value)
                .font(.bbip(.body2_m14))
                .foregroundStyle(.gray9)

            if let additional = additionalValue {
                Text("(\(additional))")
                    .font(.bbip(.body2_m14))
                    .foregroundStyle(.gray9)
                    .padding(.leading, 10)
            }

            Spacer()
        }
    }
}

// MARK: - Study Day and Time Row
struct StudyDayTimeRow: View {
    let daysOfWeek: [Int]
    let studyTimes: [StudyTime]

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("요일")
                .font(.bbip(.body1_m16))
                .foregroundStyle(.gray7)
                .padding(.trailing, 63)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(zip(daysOfWeek, studyTimes)), id: \.0) { day, time in
                    HStack {
                        Text(dayName(for: day))
                        Text("\(time.startTime) ~ \(time.endTime)")
                    }
                    .font(.bbip(.body2_m14))
                }
                .padding(.trailing, 16)
            }
            
            Spacer()
        }
    }
}
