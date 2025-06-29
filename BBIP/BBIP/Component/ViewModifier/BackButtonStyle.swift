//
//  BackButtonStyle.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import SwiftUI

// 뒤로가기 버튼의 커스텀 액션을 위한 EnvironmentKey를 정의합니다.
private struct BackButtonActionKey: EnvironmentKey {
    // 기본값은 nil로 설정하여, 커스텀 액션이 지정되지 않았음을 나타냅니다.
    static var defaultValue: (() -> Void)? = nil
}

// EnvironmentValues에 새로운 변수를 추가하여 쉽게 접근할 수 있도록 합니다.
extension EnvironmentValues {
    var backButtonAction: (() -> Void)? {
        get { self[BackButtonActionKey.self] }
        set { self[BackButtonActionKey.self] = newValue }
    }
}

struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    private let isReversal: Bool
    private let customAction: (() -> Void)?
    
    init(isReversal: Bool, customAction: (() -> Void)?) {
        self.isReversal = isReversal
        self.customAction = customAction
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if let action = customAction {
                            // 커스텀 customAction() 있는 경우만 실행
                            action()
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

extension View {
    func backButtonStyle(isReversal: Bool = false, customAction: (() -> Void)? = nil) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .modifier(BackButtonModifier(isReversal: isReversal, customAction: customAction))
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
