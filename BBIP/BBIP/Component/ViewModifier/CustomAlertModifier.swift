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
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isPresented = false
                        }

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
    }
}

// MARK: - Extension
/// 아래와 같이 사용 가능
/// .CustomAlertModifier(
///     isPresented: Binding<Bool>,   화면 표시 여부
///     title: String? = nil,                       제목 (선택)
///     message: String,                        주요 메세지 텍스트
///     cancelText: String,                     왼쪽 버튼 텍스트(기본값: "취소")
///     confirmText: Color,                     오른쪽 버튼 텍스트(기본값: "확인")
///     confirmAction: @escaping () -> Void     오른쪽 버튼 기능
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
            }
            .frame(maxHeight: 52)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 34)
    }
}
