//
//  UILabel+Extension.swift
//  10PlayApp
//
//  Created by savan soni on 30/03/26.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        guard let text = text, !text.isEmpty else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
