//
//  StudySwitchView.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import SwiftUI
import LinkNavigator

struct StudySwitchView: View {
    let navigator: LinkNavigatorType
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppStateManager
    @Binding var selectedTab: MainHomeTab
    @Binding var ongoingStudyData: [StudyInfoVO]?
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                if let studies = ongoingStudyData {
                    if studies.isEmpty {
                        StudySwitchViewCellPlaceholder()
                    } else {
                        ForEach(studies.indices, id: \.self) { index in
                            StudySwitchViewCell(study: studies[index])
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                    selectedTab = .studyHome(studyId: studies[index].studyId, studyName: studies[index].studyName)
                                }
                        }
                    }
                }
            }
            .padding(.top, 10)
            
            MainButton(text: "스터디 생성하기", font: .bbip(.button2_m16)) {
                presentationMode.wrappedValue.dismiss()
                appState.push(.startSIS)
            }
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.gray2)
    }
}

private struct StudySwitchViewCell: View {
    
    var study: StudyInfoVO
    
    private var dayAndTimeText: String {
        "\(study.totalWeeks)주 / \(study.studyStartDate) ~ \(study.studyEndDate)"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 94)
                .padding(.horizontal, 20)
            
            HStack(spacing: 24) {
                LoadableImageView(imageUrl: study.imageUrl)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 14) {
                        Text(study.studyName)
                            .font(.bbip(.body1_sb16))
                            .foregroundStyle(.mainBlack)
                            .frame(height: 20)
                        
                        CapsuleView(title: study.category.rawValue, type: .fill)
                        
                        Spacer()
                    }
                    
                    Text(study.currentWeek.description + "주차 진행 중")
                        .font(.bbip(.body2_m14))
                        .foregroundStyle(.gray7)
                        .padding(.vertical, 6)
                    
                    Text(dayAndTimeText)
                        .font(.bbip(.caption3_r12))
                        .foregroundStyle(.gray7)
                }
            }
            .padding(.horizontal, 36)
        }
        .bbipShadow1()
    }
}


private struct StudySwitchViewCellPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray3)
                .frame(maxWidth: .infinity)
                .frame(height: 94)
                .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                Image("logo_placeholder2")
                
                Text("참여 중인 스터디가 없어요")
                    .font(.bbip(.body1_sb16))
                    .foregroundStyle(.gray6)
                
                Spacer()
            }
            .padding(.leading, 34)
        }
    }
}
