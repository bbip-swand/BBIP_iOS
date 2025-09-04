//
//  WeeklyStudyContentListView.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI

//
enum WeeklyStudyContentAlertType {
    case save
    case cancel
    
    // Alert Title
    var title: String {
        switch self {
            case .save: return "수정된 내용을 저장할까요?"
            case .cancel: return "저장하지 않고 나가시겠습니까?"
        }
    }
    
    // Alert Message
    var message: String {
        switch self {
            case .save: return "저장 후에는 취소할 수 없어요?"
            case .cancel: return "수정한 내용이 모두 사라집니다"
        }
    }
    
    var confirmText: String {
        switch self {
            case .save: return "저장하기"
            case .cancel: return "나가기"
        }
    }
}

/// 주차별 활동 전체보기 뷰 (스터디 홈)
struct WeeklyStudyContentListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: WeeklyStudyContentListViewModel
    
    init(fullStudyInfo: FullStudyInfoVO) {
        _viewModel =  StateObject(wrappedValue:DIContainer.shared.makeWeeklyStudyEditViewModel(fullStudyInfoVO: fullStudyInfo)
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
            .backButtonStyle(
                customAction: viewModel.isModify && viewModel.isContentChanged ? {viewModel.isPresentedCancel()} : nil
            )
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
                    viewModel.alertType = .save
                    viewModel.isAlertPresented = true
                }
            }
        }
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
        }
        // 수정 완료 alert 표기
        .fullScreenCover(isPresented: $viewModel.isCompletePresented) {
            completeAlert
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
        .customAlert(
            isPresented: $viewModel.isAlertPresented,
            title: viewModel.alertType.title,
            message: viewModel.alertType.message,
            confirmText: viewModel.alertType.confirmText) {
                switch viewModel.alertType {
                    case .save:
                        // 수정 저장하기
                        viewModel.saveChanges()
                    case .cancel:
                        // 수정 취소하기
                        viewModel.cancelChanges()
                        presentationMode.wrappedValue.dismiss()
                }
            }
        .sheet(isPresented: $viewModel.isEditSheetPresented,
               onDismiss: {
            // 드래그로 수정 종료했을 경우
            viewModel.sheetDragCancel()
        }) {
            editingSheet
                .presentationDetents([.height(370)])
        }
    }
    
    // MARK: - cardButtonView
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
    
    // MARK: - completeAlert
    /// 수정 완료 alert view
    var completeAlert: some View {
        ZStack{
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Image("complete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 53, height: 53)
                
                VStack(spacing: 4) {
                    Text("수정 완료!")
                        .font(.bbip(.title3_m20))
                        .multilineTextAlignment(.center)
                    
                    Text("최신 내용으로 업데이트했어요")
                        .font(.bbip(.body2_m14))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
        }
        .presentationBackground(.clear)
    }
    
    // MARK: - editingSheet
    // 수정하기 sheet View
    var editingSheet: some View {
        VStack(spacing: 0) {
            Text("주차별 계획 작성")
                .font(.bbip(.button1_m20))
                .padding(.top, 20)
            
            Spacer().frame(height: 33)
            
            // 선택 주차
            CapsuleView(title: "\(viewModel.selectedIndex! + 1)주차", type: .fill)
            
            Spacer().frame(height: 10)
            
            // 주차 계획 수정 Editor
            ZStack(alignment: .topLeading) {
                if viewModel.textForEditing.isEmpty {
                    Text("주차 계획을 입력해주세요")
                        .font(.bbip(.body2_m14))
                        .foregroundStyle(.gray5)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
                
                // 실제 텍스트 에디터
                TextEditor(text: $viewModel.textForEditing)
                    .font(.bbip(.body2_m14))
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 9)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray4, lineWidth: 2)
            )
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            MainButton(text: "수정하기") {
                viewModel.updateSelectedContent()
            }
            .padding(.bottom, 16)
        }
    }
}
