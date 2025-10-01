//
//  CapsuleView.swift
//  BBIP
//
//  Created by 이건우 on 9/9/24.
//

import SwiftUI

enum CapsuleViewType {
    case normal
    case highlight
    case fill
    case timeRing
    case placeholder
}

struct CapsuleView: View {
    private let title: String
    private let type: CapsuleViewType
    
    init(
        title: String,
        type: CapsuleViewType = .normal
    ) {
        self.title = title
        self.type = type
    }
    
    var titleColor: Color {
        switch type {
        case .normal, .fill, .timeRing:
            return .gray8
        case .highlight:
            return .primary3
        case .placeholder:
            return .mainWhite
        }
    }
    
    var borderColor: Color {
        switch type {
        case .normal:
            return .gray7
        case .highlight:
            return .primary3
        case .fill, .timeRing, .placeholder:
            return .clear
        }
    }
    
    var backgroundColor: Color {
        switch type {
        case .fill, .timeRing:
            return .gray2
        case .placeholder:
            return .gray4
        default:
            return .clear
        }
    }
    
    var body: some View {
        Text(title)
            .font(.bbip(.caption2_m12))
            .foregroundStyle(titleColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .radiusBorder(cornerRadius: 10, color: borderColor, lineWidth: 1)
            .background(
                RoundedRectangle(cornerRadius: 10).fill(backgroundColor)
            )
    }
}

#Preview {
    CapsuleView(title: "가나다라", type: .highlight)
}
