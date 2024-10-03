//
//  CalendarView.swift
//  BBIP
//
//  Created by 이건우 on 9/14/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarviewModel = DIContainer.shared.makeCalendarVieModel()
    @State var addScheduleView = false
    @State var selectedDate = Date()
    @State private var currentMonthTitle: String = ""
    @State private var currentYear: String = ""
    @State private var currentMonth: String = ""
    
    private func updateCurrentMonthTitle() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM"
        let currentDate = Date()
        currentMonthTitle = formatter.string(from: currentDate)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        if let year = components.year, let month = components.month {
            currentYear = String(year)
            currentMonth = String(format: "%02d", month)
            print("Updated Year: \(currentYear), Updated Month: \(currentMonth)")
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(currentMonthTitle)
                    .font(.bbip(.title4_sb24))
                    .foregroundStyle(.gray9)
                    .padding(.leading, 20)
                    .onAppear {
                        updateCurrentMonthTitle()
                    }
                
                Spacer()
                
                Button {
                    addScheduleView = true
                } label: {
                    Image("add_schedule")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 28)
                }
            }
            .frame(height: 42)
            
            BBIPCalendar(
                vo: calendarviewModel.getYMdata,
                selectedDate: $selectedDate,
                currentMonthTitle: $currentMonthTitle,
                currentYear: $currentYear,
                currentMonth: $currentMonth,
                onPageChange: { year, month in
                    calendarviewModel.getYearMonth(year: year, month: month)
                }
            )
            .frame(height: 280)
            .padding(.vertical, 18)
            
            Rectangle()
                .foregroundStyle(.gray3)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
            SelectedDateEventView(selectedDate: selectedDate, events: calendarviewModel.getYMdata)
        }
        .navigationDestination(isPresented: $addScheduleView) {
            CreateSchedule()
        }
        .onAppear {
            // 초기 화면 진입 시 현재 연도와 월 정보로 업데이트
            updateCurrentMonthTitle()
            calendarviewModel.getYearMonth(year: currentYear, month: currentMonth)
        }
    }
}


private struct SelectedDateEventView: View {
    var selectedDate: Date
    var events: [CalendarHomeVO]
    
    private func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private func formattedWeekday(for date: Date) -> String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        weekdayFormatter.dateFormat = "E"
        return weekdayFormatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            Color.gray1
            
            VStack {
                HStack(spacing: 5) {
                    Text(formattedDate(for: selectedDate))
                        .monospacedDigit()
                        .font(.bbip(.title3_sb20))
                    
                    Text(formattedWeekday(for: selectedDate))
                        .font(.bbip(.title3_m20))
                    
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding(.top, 22)
                
                ScrollView(.vertical) {
                    ForEach(events.filter { event in
                        Calendar.current.isDate(selectedDate, inSameDayAs: event.startDate) ||
                        Calendar.current.isDate(selectedDate, inSameDayAs: event.endDate) ||
                        (selectedDate > event.startDate && selectedDate < event.endDate)
                    }, id: \.scheduldId) { event in
                        scheduleCardView(
                            scheduleTitle: event.scheduleTitle,
                            studyName: event.studyName,
                            timeRange: formattedTimeRange(start: event.startDate, end: event.endDate)
                        )
                    }
                }
                .padding(.bottom, 90)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func formattedTimeRange(start: Date, end: Date) -> String {
        let adjustedStart = start.addingTimeInterval(-9 * 3600)
        let adjustedEnd = end.addingTimeInterval(-9 * 3600)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return "\(formatter.string(from: adjustedStart)) ~ \(formatter.string(from: adjustedEnd))"
    }
}

struct scheduleCardView: View {
    var scheduleTitle: String = ""
    var studyName: String = ""
    var timeRange: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.mainWhite)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 1) {
                HStack(alignment: .top) {
                    if textWidth(for: scheduleTitle, font: UIFont.systemFont(ofSize: 14)) > 180 {
                        // 텍스트 길이가 일정한 기준보다 클 때
                        ScrollView(.vertical, showsIndicators: false) {
                            Text(scheduleTitle)
                                .font(.bbip(.body2_m14))
                                .foregroundColor(.mainBlack)
                        }
                        .frame(width: 180, height: 34) // 너비와 높이 고정
                        .clipped()
                    } else {
                        // 텍스트 길이가 기준보다 작을 때
                        Text(scheduleTitle)
                            .font(.bbip(.body2_m14))
                            .foregroundColor(.mainBlack)
                            .frame(width: 180, alignment: .leading) // 좌측 상단 정렬
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray2)
                            .frame(width: textWidth(for: studyName, font: UIFont.systemFont(ofSize: 12)) > 100 ? 116 : textWidth(for: studyName, font: UIFont.systemFont(ofSize: 12)) + 16)
                            .frame(height: 24)
                        
                        if textWidth(for: studyName, font: UIFont.systemFont(ofSize: 12)) > 100 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text(studyName)
                                    .font(.bbip(.caption2_m12))
                                    .foregroundColor(.mainBlack)
                            }
                            .frame(width: 100) // ScrollView의 크기를 고정
                            .clipped()
                        } else {
                            Text(studyName)
                                .font(.bbip(.caption2_m12))
                                .foregroundColor(.mainBlack)
                                .frame(alignment: .center)
                        }
                    }
                    .padding(.trailing, 11)
                }
                .padding(.leading, 13)
                .padding(.bottom, 4)
                
                Text(timeRange)
                    .font(.bbip(.caption3_r12))
                    .foregroundStyle(.gray7)
                    .padding(.leading, 13)
            }
            .padding(.vertical, 12)
        }
    }
    
    private func textWidth(for text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
    
}
