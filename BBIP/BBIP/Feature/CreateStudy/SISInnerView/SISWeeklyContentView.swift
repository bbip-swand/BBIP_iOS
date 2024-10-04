//
//  SISWeeklyContentView.swift
//  BBIP
//
//  Created by 이건우 on 8/31/24.
//

import SwiftUI

struct SISWeeklyContentView: View {
    @ObservedObject var viewModel: CreateStudyViewModel
    @State private var selectedWeekIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            EditPeriodButton(viewModel: viewModel) {
                viewModel.goEditPeriod = true
                hideKeyboard()
            }
            .padding(.top, 166)
            .padding(.horizontal, 20)
            
            WeeklyContentCardView(
                viewModel: viewModel,
                selectedCardNum: $selectedWeekIndex
            )
            .padding(.top, 24)
            
            CustomTextEditor(
                text: Binding(
                    get: {
                        guard viewModel.weeklyContentData[selectedWeekIndex] != nil else { return "" }
                        if let selectedIndexData = viewModel.weeklyContentData[selectedWeekIndex] {
                            return selectedIndexData
                        } else {
                            return ""
                        }
                    },
                    set: { newValue in
                        // 인덱스가 유효할 때만 업데이트
                        if selectedWeekIndex >= 0 && selectedWeekIndex < viewModel.weeklyContentData.count {
                            viewModel.weeklyContentData[selectedWeekIndex] = newValue
                        }
                    }
                ),
                characterLimit: 60,
                height: 100,
                showLimitStatus: false
            )
            .padding(.top, 22)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .keyboardHideable()
    }
}

/* 수정 방법 변경으로 인해 사용 중단
 // @State private var showEditPeriodView: Bool = false
 
 .sheet(isPresented: $showEditPeriodView) {
 SISPeriodView(viewModel: viewModel, sheetMode: true)
     .presentationDragIndicator(.visible)
     .presentationDetents([.height(300)])
     .presentationBackground(.gray9)
}
*/

private struct EditPeriodButton: View {
    @ObservedObject var viewModel: CreateStudyViewModel
    typealias Action = () -> Void
    let action: Action
    
    init(
        viewModel: CreateStudyViewModel,
        action: @escaping Action
    ) {
        self.viewModel = viewModel
        self.action = action
    }
    
    // 시간 포맷터 MM.dd
    private func formattedTime(for date: Date) -> String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "MM.dd"
        return weekdayFormatter.string(from: date)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 210, height: 32)
                    .foregroundStyle(.gray8)
                
                HStack(spacing: 7) {
                    Text("\(viewModel.weekCount)주차")
                        
                    Capsule()
                        .foregroundColor(.gray6)
                        .frame(width: 1, height: 10)
                    
                    Text("주 \(viewModel.selectedDayIndex.count)회")
                    
                    Capsule()
                        .foregroundColor(.gray6)
                        .frame(width: 1, height: 10)
                    
                    Text("\(formattedTime(for: viewModel.startDate)) ~ \(formattedTime(for: viewModel.deadlineDate!))")
                    
                    Image("common_edit")
                }
                .font(.bbip(.caption2_m12))
                .foregroundStyle(.mainWhite)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct WeeklyContentCardView: View {
    @ObservedObject var viewModel: CreateStudyViewModel
    @Binding var selectedCardNum: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<viewModel.weekCount, id: \.self) { value in
                    Button {
                        selectedCardNum = value
                    } label: {
                        createCard(value: value)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func createCard(value: Int) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 56, height: 56)
            .foregroundStyle(
                selectedCardNum == value ? .primary3 : .gray8
            )
            .overlay {
                Text("\(value + 1)R")
                    .font(.bbip(.title4_sb24))
                    .foregroundStyle(
                        selectedCardNum == value ? .mainWhite : .gray6
                    )
            }
    }
}
