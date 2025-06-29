//
//  WeeklyStudyContentListViewModel.swift
//  BBIP
//
//  Created by 최주원 on 6/29/25.
//

import SwiftUI

class WeeklyStudyContentListViewModel: ObservableObject {
    // MARK: - Properties
    let isManager: Bool     // 관리자 여부
    private var originalContent: [String]       // 기존 내용(비교 용도)
    @Published var modifiedContent: [String]    // 수정된 내용(임시 저장소)
    @Published var isModify: Bool = false       // 수정모드 진입 여부
    @Published var selectedIndex: Int? = nil    // 선택된 카드 index
    @Published var textForEditing: String = ""  // 수정 텍스트 임시 저장소
    // Presented
    @Published var isEditSheetPresented: Bool = false   // 수정 sheet 표시
    @Published var isAlertPresented: Bool = false   // 수정 sheet 표시
    @Published var isCompletePresented: Bool = false   // 수정 완료 표시
    
    var alertType: WeeklyStudyContentAlertType = .save
    
    /// 내용 수정 여부
    var isContentChanged: Bool { originalContent != modifiedContent }
    
    /// 수정 버튼 표시 여부
    var editButtonPresented: Bool { isManager && !isModify }
    
    // MARK: - Initializer
    init(weeklyStudyContent: [String], isManager: Bool) {
        self.originalContent = weeklyStudyContent
        self.modifiedContent = weeklyStudyContent // 초기에는 원본과 동일하게 설정
        self.isManager = isManager
    }
    
    // MARK: - Functions
    /// 수정 모드 전환
    func enterModifyMode() {
        withAnimation(.easeInOut(duration: 0.15)) {
            isModify = true
        }
    }
    
    /// 수정 모드 진입
    func selectCard(at index: Int) {
        guard isModify else { return }
        textForEditing = modifiedContent[index]
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedIndex = index
            isEditSheetPresented = true
        }
    }
    
    // 수정 취소 alert 표시
    func isPresentedCancel() {
        // 다를 경우만 alert 표시
        if isContentChanged {
            alertType = .cancel
            isAlertPresented = true
        } else {
            withAnimation(.easeInOut(duration: 0.15)) {
                isModify = false
            }
        }
    }
    
    /// 선택 주차 수정 완료
    func updateSelectedContent() {
        if let index = selectedIndex {
            modifiedContent[index] = textForEditing
        }
        // Sheet를 닫고 선택 상태를 초기화
        isEditSheetPresented = false
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedIndex = nil
        }
        textForEditing = ""
    }
    
    /// 수정된 내용 저장
    func saveChanges() {
        // 저장 코드 추가
        withAnimation(.easeInOut(duration: 0.15)) {
            isModify = false
        }
        
        // api 코드 추가
        
        
        // 저장 완료 alert 표시
        isCompletePresented = true
        originalContent = modifiedContent
        
        Task {
            // 1.5초 지연
            try? await Task.sleep(nanoseconds: UInt64(1.5) * 1_000_000_000)
            await MainActor.run {
                self.isCompletePresented = false
            }
        }
    }
    
    /// 수정 취소
    func cancelChanges() {
        modifiedContent = originalContent
        withAnimation(.easeInOut(duration: 0.15)) {
            isModify = false
        }
    }
    
    /// 수정 sheet 드래그 취소 이벤트
    func sheetDragCancel() {
        isEditSheetPresented = false
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedIndex = nil
        }
    }
}
