//
//  SetStudyLocationView.swift
//  BBIP
//
//  Created by 이건우 on 10/1/24.
//

import SwiftUI
import Combine

/// 팀장만 접근 가능
struct SetStudyLocationView: View {
    @State private var locationText: String = ""
    @State private var showLocationCheckView: Bool = false
    
    // simple task
    private let dataSource = StudyDataSource()
    private let studyId: String
    private let currentWeek: Int
    
    init(
        prevLocation: String,
        studyId: String,
        currentWeek: Int
    ) {
        self.locationText = prevLocation
        self.studyId = studyId
        self.currentWeek = currentWeek
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 72)
            
            Group {
                Text("이번 주차 장소를 입력하세요")
                    .font(.bbip(.title4_sb24))
                    .padding(.bottom, 13)
                
                Text("팀원들에게 정확한 위치를 알려주세요")
                    .font(.bbip(.caption1_m16))
                    .foregroundStyle(.gray6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 50)
            
            Group {
                TextField("ex) 예대 415호", text: $locationText)
                    .font(.bbip(.title3_m20))
                    .multilineTextAlignment(.center)
                    .frame(height: 46)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.gray3)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
            
            
            Spacer()
            
            MainButton(text: "다음", enable: !locationText.trimmingCharacters(in: .whitespaces).isEmpty) {
                dataSource.editStudyLocation(studyId: studyId, session: currentWeek, location: locationText) { result in
                    switch result {
                    case .success:
                        showLocationCheckView = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .padding(.bottom, 22)
        }
        .keyboardHideable()
        .backButtonStyle()
        .background(.gray1)
        .navigationDestination(isPresented: $showLocationCheckView) {
            CheckStudyLocationView(location: locationText, isManager: true)
        }
    }
}

