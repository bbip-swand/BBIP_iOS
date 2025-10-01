//
//  UISHeaderView.swift
//  BBIP
//
//  Created by 이건우 on 8/25/24.
//

import SwiftUI

struct TabViewHeaderView: View {
    var title: String
    var subTitle: String
    var reversal: Bool
    
    init(
        title: String,
        subTitle: String = "",
        reversal: Bool = false
    ) {
        self.title = title
        self.subTitle = subTitle
        self.reversal = reversal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.bbip(.title4_sb24))
                .foregroundStyle(reversal ? .mainWhite : .mainBlack)
            
            Text(subTitle)
                .font(.bbip(family: .Regular, size: 16))
                .foregroundStyle(.gray6)
                .padding(.top, 16)
        }
    }
}

#Preview {
    TabViewHeaderView(
        title: "This is Title",
        subTitle: "This is subTitle"
    )
}
