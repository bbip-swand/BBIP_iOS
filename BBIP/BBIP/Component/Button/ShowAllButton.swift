//
//  ShowAllButton.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI

struct ShowAllButton: View {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text("전체보기")
                    .font(.bbip(.body2_m14))
                Image("detail_rightArrow")
            }
            .foregroundStyle(.gray7)
        }
    }
}
