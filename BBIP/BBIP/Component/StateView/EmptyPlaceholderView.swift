//
//  EmptyPlaceholderView.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    let message: String
    let bottomPadding: CGFloat
    
    init(
        message: String,
        bottomPadding: CGFloat = 0
    ) {
        self.message = message
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("nostudy")
                .resizable()
                .frame(width: 80, height: 80)

            Text(message)
                .font(.bbip(.title3_sb20))
                .foregroundStyle(.gray7)
                .frame(maxWidth: .infinity)
                .padding(.top, 23)
                .padding(.bottom, 42 + bottomPadding) // navBar heigt 42
            Spacer()
        }
        .background(.gray1)
    }
}
