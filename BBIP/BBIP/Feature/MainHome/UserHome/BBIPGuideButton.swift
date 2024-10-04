//
//  BBIPGuideButton.swift
//  BBIP
//
//  Created by 이건우 on 9/11/24.
//

import SwiftUI

struct BBIPGuideButton: View {
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    var body: some View {
        Image("bbip_guide")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width - 34)
            .bbipShadow1()
            .onTapGesture {
                openURL("https://possible-raft-360.notion.site/BBIP-114aea0c293b81d7820ae57115c6af3f")
            }
    }
}

#Preview {
    BBIPGuideButton()
}
