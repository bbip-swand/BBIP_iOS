//
//  WarningLabel.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI

struct WarningLabel: View {
    private let errorText: String
    
    init(errorText: String) {
        self.errorText = errorText
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Image("warning")
                .resizable()
                .frame(width: 17, height: 17)
            
            Text(errorText)
                .font(.bbip(.caption2_m12))
        }
        .foregroundStyle(.primary3)
    }
}

#Preview {
    WarningLabel(errorText: "실명을 작성해주세요. 숫자, 특수문자는 사용할 수 없습니다.")
}
