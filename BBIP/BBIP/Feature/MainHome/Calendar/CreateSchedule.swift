//
//  CreateSchedule.swift
//  BBIP
//
//  Created by 조예린 on 10/1/24.
//

import Foundation
import SwiftUI
import Combine

//TODO: -완료눌렀을때 홈화면으로 돌아가도록
struct CreateSchedule: View{
    @EnvironmentObject var appState: AppStateManager
    @StateObject var calendarviewModel = DIContainer.shared.makeCalendarVieModel()
    @State private var isDropdownVisible: Bool = false
    @State private var selectedStudyName: String = ""
    @State private var titleText: String = ""
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @State private var showStartTimePicker: Bool = false
    @State private var showEndTimePicker: Bool = false
    @State var isHomeView:Bool = false
    @State var iconType : Int = 0
    @State var selectedStudyId: String = ""
    
    
    // 날짜와 시간 데이터
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var startTime: Date?
    @State private var endTime: Date?
    
    var body: some View{
        VStack(spacing:0){
            
            
            selectStudy
                .padding(.horizontal, 16)
                .padding(.top, 22)
            
            scheduleTitle
                .frame(height: 41)
                .padding(.horizontal, 16)
                .padding(.top,8)
            
            chooseDate
                .padding(.horizontal,16)
                .padding(.top,32)
            
            seeHomeView
                .padding(.horizontal,16)
                .padding(.top,32)
                .bbipShadow1()
            
            if isHomeView{
                iconView
                    .padding(.horizontal,16)
                    .padding(.top,8)
                    .animation(.easeInOut, value: isHomeView)
            }
            
            Spacer()
        }
        .textBackButtonStyle(buttonText: "취소")
        .background(.gray1)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    createSchedule()
                    appState.popToRoot()
                } label: {
                    Text("완료")
                        .font(.bbip(.button2_m16))
                        .foregroundStyle(.primary3)
                }
            }
        }
        .onAppear(){
            calendarviewModel.getMystudy()
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
            isDropdownVisible = false
        }
    }
    
    var selectStudy: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 41)
                .frame(maxWidth: .infinity)
                .foregroundColor(.mainWhite)
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isDropdownVisible.toggle()
                }
            }) {
                Text(selectedStudyName.isEmpty ? "스터디선택" : selectedStudyName)
                    .font(.bbip(.body2_m14))
                    .foregroundColor(selectedStudyName.isEmpty ? .gray5 : .mainBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .lineLimit(1) // 한 줄로 제한
                    .truncationMode(.tail)
            }
            .disabled(calendarviewModel.mystudies.isEmpty) // mystudies가 빈 배열일 경우 버튼 비활성화
            .bbipShadow1()
            
            if isDropdownVisible {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(calendarviewModel.mystudies.filter { !$0.studyName.isEmpty }, id: \.studyId) { mystudy in
                        Button(action: {
                            selectedStudyId = mystudy.studyId
                            selectedStudyName = mystudy.studyName
                            isDropdownVisible = false
                        }) {
                            Text(mystudy.studyName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.mainWhite)
                                .foregroundColor(.mainBlack)
                                .font(.bbip(.body2_m14)) // 버튼 폰트 스타일 설정
                                .frame(height: 41) // 버튼 높이 설정
                        }
                        .background(.mainWhite)
                        .cornerRadius(12)
                        Divider()
                    }
                }
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.mainWhite)
                        .bbipShadow1()
                )
            }
        }
        
    }
    
    var scheduleTitle: some View{
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.mainWhite)
                .bbipShadow1()
                .frame(height: 41)
                .frame(maxWidth: .infinity)
            
            TextField("", text: $titleText, prompt: Text("제목 입력").foregroundColor(.gray5))
                .padding(.horizontal, 14) // 텍스트 필드 안쪽의 여백
                .font(.bbip(.body2_m14))
                .foregroundColor(.mainBlack)// 입력 중 폰트 색상
        }
    }
    
    var chooseDate: some View{
        VStack(spacing:8){
            ZStack{
                RoundedRectangle(cornerRadius:12)
                    .frame(height: 41)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.mainWhite)
                
                HStack(spacing:0){
                    Text("시작일")
                        .font(.bbip(.body2_m14))
                        .foregroundColor(.mainBlack)
                        .padding(.leading,16)
                    
                    Spacer()
                    
                    Button {
                        showStartDatePicker.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray2)
                                .frame(width:105, height:31)
                            
                            Text(startDate == nil ? "시작일" : formattedDate(for: startDate!))
                                .font(.bbip(.body2_m14))
                                .foregroundColor(startDate == nil ? .gray5 : .mainBlack)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    // 시작 시간
                    Button {
                        showStartTimePicker.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray2)
                                .frame(width: 69, height: 31)
                            
                            Text(startTime == nil ? "시간" : formattedTime(for: startTime!))
                                .font(.bbip(.body2_m14))
                                .foregroundColor(startTime == nil ? .gray5 : .mainBlack)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.leading,8)
                    .padding(.trailing,16)
                    
                    
                }
            }
            
            ZStack{
                RoundedRectangle(cornerRadius:12)
                    .frame(height: 41)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.mainWhite)
                
                HStack(spacing:0){
                    Text("종료일")
                        .font(.bbip(.body2_m14))
                        .foregroundColor(.mainBlack)
                        .padding(.leading,16)
                    
                    Spacer()
                    
                    Button {
                        showEndDatePicker.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray2)
                                .frame(width:105, height:31)
                            
                            Text(endDate == nil ? "종료일" : formattedDate(for: endDate!))
                                .font(.bbip(.body2_m14))
                                .foregroundColor(endDate == nil ? .gray5 : .mainBlack)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    
                    
                    Button {
                        showEndTimePicker.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray2)
                                .frame(width:69, height:31)
                            
                            Text(endTime == nil ? "시간" : formattedTime(for: endTime!))
                                .font(.bbip(.body2_m14))
                                .foregroundColor(endTime == nil ? .gray5 : .mainBlack)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.leading,8)
                    .padding(.trailing,16)
                    
                }
            }
        }
        .sheet(isPresented: $showStartDatePicker) {
            DatePicker(
                "시작일",
                selection: Binding(get: { startDate ?? Date() }, set: { newValue in
                    startDate = combineDateAndTime(date: newValue, time: startTime)
                }),
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
            .accentColor(.mainWhite)
            .colorMultiply(startDate != nil ? .primary3 : .primary3 )
        }
        .sheet(isPresented: $showEndDatePicker) {
            DatePicker("종료일", selection: Binding(get: { endDate ?? Date() }, set: { newValue in
                endDate = combineDateAndTime(date: newValue, time: endTime)
            }),
                       in: Date()...,
                       displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
            .accentColor(.mainWhite)
            .colorMultiply(startDate != nil ? .primary3 : .primary3 )
        }
        .sheet(isPresented: $showStartTimePicker) {
            DatePicker("", selection:  Binding(get: { startTime ?? Date() }, set: { newValue in
                startDate = combineDateAndTime(date: startDate, time: newValue)
                startTime = newValue
            }), displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .padding()
            .presentationDetents([.height(250)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showEndTimePicker) {
            DatePicker("", selection:  Binding(get: { endTime ?? Date() }, set: { newValue in
                endDate = combineDateAndTime(date: endDate, time: newValue)
                endTime = newValue
            }), displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())
            .padding()
            .presentationDetents([.height(250)])
            .presentationDragIndicator(.visible)
        }
    }
    
    
    var seeHomeView: some View{
        ZStack{
            RoundedRectangle(cornerRadius:12)
                .frame(height: 41)
                .frame(maxWidth: .infinity)
                .foregroundColor(.mainWhite)
            
            HStack(spacing:0){
                Text("홈에서 보기")
                    .font(.bbip(.body2_m14))
                    .foregroundColor(.mainBlack)
                    .padding(.leading,16)
                
                Spacer()
                
                ZStack {
                    // Background Capsule (토글 전체 배경)
                    Capsule()
                        .fill(isHomeView ? .primary3: .gray3)
                        .frame(width: 45, height: 28)
                        .animation(.easeInOut, value: isHomeView)
                    
                    // Circle Handle (토글 원)
                    HStack {
                        if isHomeView {
                            Spacer().frame(width:17)
                        }
                        Circle()
                            .fill(.mainWhite)
                            .frame(width: 20, height: 20)
                            .animation(.easeInOut, value: isHomeView)
                        if !isHomeView {
                            Spacer().frame(width:17)
                        }
                    }
                    .padding(.horizontal,4)
                }
                .onTapGesture {
                    isHomeView.toggle() // Toggle 상태 변경
                }
                .padding(.trailing,13)
            }
        }
    }
    
    var iconView : some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.mainWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 142) // 높이 설정은 한 번만
            
            HStack(alignment: .top, spacing: 0) {
                Text("아이콘")
                    .font(.bbip(.body2_m14))
                    .foregroundColor(.mainBlack)
                    .padding(.leading, 14)
                
                Spacer()
                
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ForEach(1...4, id: \.self) { index in
                            Button{
                                iconType = index
                            }label: {
                                Image("dday_icon\(index)")
                                    .resizable()
                                    .frame(width: 53, height: 53)
                                    .overlay(
                                        Circle()
                                            .stroke(.primary3, lineWidth: iconType == index ? 1.5 : 0)
                                    )
                            }
                        }
                    }
                    HStack(spacing: 12) {
                        ForEach(5...8, id: \.self) { index in
                            Button{
                                iconType = index
                            }label: {
                                Image("dday_icon\(index)")
                                    .resizable()
                                    .frame(width: 53, height: 53)
                                    .overlay(
                                        Circle()
                                            .stroke(.primary3, lineWidth: iconType == index ? 1.5 : 0)
                                    )
                            }
                        }
                    }
                }
                .padding([.trailing, .leading], 13) // 좌우 패딩
            }
            .padding(.vertical, 12) // ZStack 안에서 HStack 상하 여백
        }
        .bbipShadow1()
    }
    
    // 날짜와 시간을 합쳐 새로운 Date 객체로 반환하는 함수
    private func combineDateAndTime(date: Date?, time: Date?) -> Date {
        guard let date = date else { return Date() }
        guard let time = time else { return date }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? date
    }
    
    // 날짜를 형식에 맞춰 변환하는 함수
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    // 시간을 형식에 맞춰 변환하는 함수
    private func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatToISO8601(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: date)
    }
    
    private func createSchedule() {
        guard let startDate = startDate, let endDate = endDate else {
            print("날짜가 선택되지 않았습니다.")
            return
        }
        
        print("(STartDate: \(startDate)")

        // startDate와 endDate를 ISO 8601 형식으로 포맷팅
        let formattedStartDate = formatToISO8601(date: startDate)
        let formattedEndDate = formatToISO8601(date: endDate)
        print("FormattedStartDate: \(formattedStartDate)")
            let createSchedulevo = CreateScheduleVO(
                studyId: selectedStudyId,
                scheduleTitle: titleText,
                startDate: formattedStartDate,
                endDate: formattedEndDate,
                isHomeView: isHomeView,
                icon: iconType
            )
        
        // Use the created VO
        print(createSchedulevo)
        
        calendarviewModel.createSchedule(scheduleVO: createSchedulevo)
    }
    
    
    
}

