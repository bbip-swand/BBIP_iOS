//
//  CustomAlertModifier.swift
//  BBIP
//
//  Created by 최주원 on 6/28/25.
//

import SwiftUI

/// CustomAlert
/// 하단 Extension을 통해 사용
struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String?
    let message: String
    let cancelText: String
    let confirmText: String
    let confirmColor: Color
    let confirmAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    // 반투명 배경
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isPresented = false
                        }

                    // 위에서 정의한 알림창 UI 뷰
                    CustomAlertView(
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        cancelText: cancelText,
                        confirmText: confirmText,
                        confirmColor: confirmColor,
                        confirmAction: confirmAction
                    )
                }
                .presentationBackground(.clear)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            .animation(.easeInOut(duration: 0.1), value: isPresented)
    }
}

// MARK: - Extension
/// 아래와 같이 사용 가능
/// .CustomAlertModifier(
///     isPresented: Binding<Bool>,
///     message: String,
///     cancelText: String,
///     confirmText: Color,
///     confirmAction: @escaping () -> Void
/// )
extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String,
        cancelText: String = "취소",
        confirmText: String = "확인",
        confirmColor: Color = .primary3,
        confirmAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                cancelText: cancelText,
                confirmText: confirmText,
                confirmColor: confirmColor,
                confirmAction: confirmAction
            )
        )
    }
}


// MARK: - CustomAlertAlert View
struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    var title: String?
    let message: String
    let cancelText: String
    let confirmText: String
    let confirmColor: Color
    let confirmAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                if let title = title {
                    Text(title)
                        .font(.bbip(.title3_m20))
                }
                Text(message)
                    .font(.bbip(.body2_m14))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(minHeight: 103)
            
            Divider()
            
            HStack(spacing: 0) {
                Button(cancelText) {
                    isPresented = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.bbip(.body2_m14))
                
                Divider()
                
                Button(confirmText) {
                    confirmAction()
                    isPresented = false
                }
                .foregroundStyle(confirmColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.bbip(.body1_m16))
                .foregroundColor(.red)
            }
            .frame(maxHeight: 52)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 34)
    }
}
