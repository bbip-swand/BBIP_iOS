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
                    LoadableImageView(imageUrl: vo.imageUrl, size: 48)
                        .padding(.trailing, 19)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vo.title)
                            .font(.bbip(.body1_sb16))
                            .foregroundStyle(.mainBlack)
                            .frame(maxWidth: 200, maxHeight: 20, alignment: .leading)
                        
                        HStack(spacing: 9) {
                            Text("\(vo.currentStudyRound)R")
                                .font(.bbip(.body2_b14))
                                .foregroundStyle(.primary3)
                            
                            if let description = vo.currentStudyDescription {
                                if description.isEmpty {
                                    Text("미정")
                                        .font(.bbip(.body2_m14))
                                        .foregroundStyle(.gray5)
                                } else {
                                    Text(description)
                                        .font(.bbip(.body2_m14))
                                        .foregroundStyle(.gray8)
                                        .frame(maxWidth: 200, maxHeight: 17, alignment: .leading)
                                }
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

struct CurrentWeekStudyInfoCardViewPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray2)
                .frame(height: 120)
                .bbipShadow1()
            
            HStack(spacing: 19) {
                Image("logo_placeholder")
                
                Text("더 이상 진행할 라운드가 없어요")
                    .font(.bbip(.body1_sb16))
                    .foregroundStyle(.gray6)
                
                Spacer()
            }
            .padding(.leading, 14)
        }
    }
}

#Preview {
    CurrentWeekStudyInfoCardViewPlaceholder()
}
