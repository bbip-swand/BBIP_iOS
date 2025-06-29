//
//  WeeklyStudyContentListView.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI

/// 주차별 활동 전체보기 뷰 (스터디 홈)
struct WeeklyStudyContentListView: View {
    @StateObject private var viewModel: WeeklyStudyContentListViewModel
    
    init(weeklyStudyContent: [String], isManager: Bool) {
        _viewModel = StateObject(wrappedValue: WeeklyStudyContentListViewModel(
            weeklyStudyContent: weeklyStudyContent,
            isManager: isManager)
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<viewModel.modifiedContent.count, id: \.self) { index in
                        cardButtonView(for: index)
                    }
                }
                .padding(.vertical, 22)
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(.gray1)
            .navigationTitle(viewModel.isModify ? "주차별 활동 수정" : "주차별 활동")
            .navigationBarTitleDisplayMode(.inline)
            .backButtonStyle()
            .toolbar{
                // 수정하기 버튼
                if viewModel.editButtonPresented {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.enterModifyMode()
                        } label: {
                            Image("common_edit_black")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            
            // 하단 수정완료 버튼
            if viewModel.isModify {
                MainButton(text: "수정하기", enable: viewModel.isContentChanged) {
                    // 수정 완료 alert 표시
                    viewModel.isSheetPresented = true
                }
            }
        }
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
        }
    }
    
    /// 주차별 카드 버튼 view
    private func cardButtonView(for index: Int) -> some View {
        Button {
            viewModel.selectCard(at: index)
        } label: {
            // CardView는 이제 클로저를 받지 않아도 됩니다.
            WeeklyStudyContentCardView(
                week: index + 1,
                content: viewModel.modifiedContent[index],
                isModify: viewModel.isModify,
                isSelected: viewModel.selectedIndex == index
            )
        }
        .disabled(!viewModel.isModify)
    }
}
