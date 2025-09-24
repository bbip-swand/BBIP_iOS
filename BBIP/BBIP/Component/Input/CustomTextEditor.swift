//
//  CustomTextEditor.swift
//  BBIP
//
//  Created by 이건우 on 9/3/24.
//

import SwiftUI
import SwiftUIIntrospect

struct CustomTextEditor: View {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    private let characterLimit: Int
    private let height: CGFloat
    private let showLimitStatus: Bool

    init(
        text: Binding<String>,
        characterLimit: Int = 100,
        height: CGFloat,
        showLimitStatus: Bool = true
    ) {
        self._text = text
        self.characterLimit = characterLimit
        self.height = height
        self.showLimitStatus = showLimitStatus
    }

    var body: some View {
        VStack(spacing: 10) {
            TextEditor(text: $text)
                .focused($isFocused)
                .foregroundStyle(.mainWhite)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused || !text.isEmpty ? Color.red : .gray3, lineWidth: 1)
                )
                .frame(height: height)
                .introspect(.textEditor, on: .iOS(.v17, .v18)) { textEditor in
                    textEditor.autocorrectionType = .no
                    textEditor.autocapitalizationType = .none
                    textEditor.spellCheckingType = .no
                    textEditor.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                    
                    // 행간 설정
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 10
                    let attributes: [NSAttributedString.Key: Any] = [
                        .paragraphStyle: paragraphStyle,
                        .font: UIFont(name: "WantedSans-Medium", size: 16)!,
                        .foregroundColor: UIColor.white
                    ]
                    
                    let currentText = textEditor.text ?? ""
                    let attributedString = NSMutableAttributedString(string: currentText, attributes: attributes)
                    textEditor.attributedText = attributedString
                }
                .onChange(of: text) { _, newValue in
                    if newValue.count >= characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }
            
            if showLimitStatus {
                Text("\(text.count)/\(characterLimit)")
                    .font(.bbip(.body2_m14))
                    .foregroundStyle(.gray6)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }   
        }
    }
}

