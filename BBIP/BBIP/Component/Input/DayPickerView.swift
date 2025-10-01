//
//  DayPickerView.swift
//  BBIP
//
//  Created by 이건우 on 9/18/24.
//

import SwiftUI

struct DayPickerView: View {
    @Binding var selectedDay: Int
    @Binding var isSheetPresented: Bool
    
    @State private var daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("요일 선택", selection: $selectedDay) {
                ForEach(0..<daysOfWeek.count, id: \.self) { index in
                    Text(daysOfWeek[index]+"요일").tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle()) // 휠 스타일 적용
            .frame(maxWidth: .infinity)
            .padding(20)
            
            MainButton(text: "확인") {
                if selectedDay == -1 {
                    selectedDay = 0 // 기본값을 월요일로 설정 (인덱스 0)
                }
                isSheetPresented = false
            }
            .padding(.bottom, 22)
        }
    }
}
