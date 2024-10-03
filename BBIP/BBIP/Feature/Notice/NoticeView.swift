//
//  NoticeView.swift
//  BBIP
//
//  Created by 이건우 on 9/9/24.
//

import SwiftUI

struct NoticeView: View {
    
    init() {
        setNavigationBarAppearance()
    }
    
    var body: some View {
        Text("This is Mypage View")
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
            .backButtonStyle(isReversal: true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // go notice setting view!
                    } label: {
                        Image("setting_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 10)
                    }
                }
            }
        
    }
}
