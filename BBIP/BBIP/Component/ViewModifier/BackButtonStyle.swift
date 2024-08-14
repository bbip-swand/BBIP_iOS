//
//  BackButtonStyle.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("backButton")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.black)
                    }
                }
            }
    }
}

extension View {
    func backButtonStyle() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .modifier(BackButtonModifier())
    }
}