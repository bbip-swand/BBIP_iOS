//
//  Text+Extension.swift
//  BBIP
//
//  Created by 이건우 on 10/2/24.
//

import SwiftUI

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string) /// create an `AttributedString`
        configure(&attributedString) /// configure using the closure
        self.init(attributedString) /// initialize a `Text`
    }
}

extension Optional where Wrapped == String {
    func unwrapped(placeholder: String = "") -> String {
        String(self ?? placeholder)
    }
}
