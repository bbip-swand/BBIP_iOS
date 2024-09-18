//
//  CurrentWeekStudyInfoCardView.swift
//  BBIP
//
//  Created by 조예린 on 8/27/24.
//

import SwiftUI

struct CurrentWeekStudyInfoCardView: View {
    private let vo: CurrentWeekStudyInfoVO
    
    init(vo: CurrentWeekStudyInfoVO) {
        self.vo = vo
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
                .frame(height: 120)
                .bbipShadow1()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Group {
                        if let imageURL = vo.imageUrl {
                            AsyncImage(url: URL(string: imageURL))
                                .frame(width: 48, height: 48)
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image("profile_default")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.trailing, 19)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vo.title)
                            .font(.bbip(.body1_sb16))
                            .foregroundStyle(.mainBlack)
                        
                        HStack(spacing: 9) {
                            Text("\(vo.currentStudyRound)R")
                                .font(.bbip(.body2_b14))
                                .foregroundStyle(.primary3)
                            
                            if let description = vo.currentStudyDescription {
                                Text(description)
                                    .font(.bbip(.body2_m14))
                                    .foregroundStyle(.gray8)
                            } else {
                                Text("미입력")
                                    .font(.bbip(.body2_m14))
                                    .foregroundStyle(.gray5)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    CapsuleView(title: vo.category.rawValue, type: .fill)
                        .frame(height: 48, alignment: .top)
                }
                Rectangle()
                    .fill(.gray3)
                    .frame(height: 1)
                    .padding(.top, 14)
                    .padding(.bottom, 12)
                
                
                HStack(spacing: 0) {
                    Image("calendar_nonactive")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 9)
                    
                    Text("\(vo.date) / \(vo.time)")
                        .padding(.trailing, 28)
                    
                    Image("home_nonactive")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 9)
                    Text(vo.location)
                }
                .font(.bbip(.caption2_m12))
                .foregroundStyle(.gray7)
            }
            .padding(.horizontal, 14)
        }
    }
}

#Preview {
    ForEach(1..<3) { int in
        CurrentWeekStudyInfoCardView(vo: CurrentWeekStudyInfoVO(
            imageUrl: nil,
            title: "가나다 스터디",
            category: .design,
            currentStudyRound: 9,
            currentStudyDescription: "오늘은 가나다",
            date: "9월 24일",
            time: "12:00 ~ 15:00",
            location: "경희대학교"))
    }
    .padding(.horizontal, 17)
}