//
//  TabViewProgressBar.swift
//  BBIP
//
//  Created by 이건우 on 8/30/24.
//

import SwiftUI

struct TabViewProgressBar: View {
    @Binding var value: Double
    
    init(value: Binding<Double>) {
        self._value = value
    }
    
    var body: some View {
        ProgressView(value: value)
            .progressViewStyle(LinearProgressViewStyle())
            .tint(.primary3)
            .animation(.easeInOut(duration: 0.1), value: value)
    }
}
