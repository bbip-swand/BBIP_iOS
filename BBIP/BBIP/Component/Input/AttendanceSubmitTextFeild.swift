import SwiftUI

/// 출석 코드 입력에 쓰이는 Custom TextFeild
struct AttendanceSubmitTextFeild: View {
    @Binding var text: String
    @Binding var isWrongCode: Bool
    @FocusState.Binding var focusedField: Int?
    
    var index: Int
    var font: Font
    var size: CGFloat = 70
    var keyboardType: UIKeyboardType = .numberPad
    var backgroundColor: Color = .gray8
    var isFocused: Bool
    var isFilled: Bool
    
    var onTextChange: (Int, String) -> Int?
    
    var body: some View {
        TextField("", text: $text)
            .font(font)
            .frame(width: size, height: size)
            .multilineTextAlignment(.center)
            .keyboardType(keyboardType)
            .frame(maxWidth: .infinity)
            .background(
                isWrongCode
                ? Color(uiColor: UIColor(hexCode: "FF9090", alpha: 0.5))
                : backgroundColor
            )
            .foregroundColor(.mainWhite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused || isFilled ? .primary3 : Color.clear,
                        lineWidth: 2
                    )
            )
            .focused($focusedField, equals: index)
            .onChange(of: text) { _, newValue in
                if let nextIndex = onTextChange(index, newValue) {
                    focusedField = nextIndex
                }
            }
    }
}
