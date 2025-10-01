//
//  TimePickerView.swift
//  BBIP
//
//  Created by 이건우 on 9/18/24.
//

import SwiftUI
import SwiftUIIntrospect

struct TimePickerView: View {
    @Binding var selectedTime: Date?
    @Binding var isSheetPresented: Bool
    
    // 기본 시간을 오전 9시로 설정
    private func defaultTime() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "",
                selection: Binding(
                    get: { selectedTime ?? defaultTime() },
                    set: { selectedTime = $0 }
                ),
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .introspect(.datePicker(style: .wheel), on: .iOS(.v17, .v18)) { datePicker in
                datePicker.minuteInterval = 10
            }
            .padding(20)
            
            MainButton(text: "확인") {
                if selectedTime == nil {
                    selectedTime = defaultTime()
                }
                isSheetPresented = false
            }
            .padding(.bottom, 22)
        }
    }
}
