//
//  BackButtonStyle.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    private let isReversal: Bool
    
    init(isReversal: Bool) {
        self.isReversal = isReversal
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("backButton")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isReversal ? .mainWhite : .gray9)
                    }
                }
            }
    }
}

extension View {
    func backButtonStyle(isReversal: Bool = false) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .modifier(BackButtonModifier(isReversal: isReversal))
    }
    
    func textBackButtonStyle(buttonText: String = "뒤로") -> some View {
            self
                .navigationBarBackButtonHidden(true)
                .modifier(TextBackButtonModifier(buttonText: buttonText))
        }
}

struct TextBackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    private let buttonText: String

    init(buttonText: String) {
        self.buttonText = buttonText
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(buttonText)
                            .foregroundStyle(.gray5)
                            .font(.bbip(.button2_m16))
                    }
                }
            }
    }
}


struct BackButtonHandlingModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentIndex: Int
    private let isReversal: Bool
    
    init(
        currentIndex: Binding<Int>,
        isReversal: Bool
    ) {
        self._currentIndex = currentIndex
        self.isReversal = isReversal
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if currentIndex > 0 {
                            withAnimation { currentIndex -= 1 }
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image("backButton")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isReversal ? .mainWhite : .gray9)
                    }
                }
            }
    }
}

/// TabView에서 selectedIndex값을 handling할 수 있는 backButton
extension View {
    func handlingBackButtonStyle(
        currentIndex: Binding<Int>,
        isReversal: Bool = false
    ) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .modifier(BackButtonHandlingModifier(currentIndex: currentIndex, isReversal: isReversal))
    }
}
