//
//  UIButton+Extension.swift
//  10PlayApp
//
//  Created by savan soni on 30/03/26.
//

import Foundation
import UIKit

extension UIButton {
    
    func setStyle(weight: RobotoWeight,
                  size: CGFloat,
                  horizontalPadding: CGFloat = 0,
                  verticalPadding: CGFloat = 0,
                  isCapsule: Bool = true,
                  kern: Double = 0.0) {
        
        let customFont = AppFont.get(weight, size: size)
        
        // Get the existing title from Storyboard or previous setup
        let buttonTitle = self.title(for: .normal) ?? self.configuration?.title ?? ""
        
        if #available(iOS 15.0, *) {
            var config = self.configuration ?? UIButton.Configuration.filled()
            
            // 1. Create AttributedString with Kern and Font
            var attributedTitle = AttributedString(buttonTitle)
            attributedTitle.font = customFont
            attributedTitle.kern = kern
            
            // Assigning this will override the plain title
            config.attributedTitle = attributedTitle
            
            // 2. Set Padding [cite: 123]
            config.contentInsets = NSDirectionalEdgeInsets(
                top: verticalPadding,
                leading: horizontalPadding,
                bottom: verticalPadding,
                trailing: horizontalPadding
            )
            
            // 3. Set Capsule Shape
            if isCapsule {
                config.cornerStyle = .capsule
            }
            
            self.configuration = config
            
        } else {
            // Fallback for older iOS versions
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .kern: kern
            ]
            let attributedString = NSAttributedString(string: buttonTitle, attributes: attributes)
            self.setAttributedTitle(attributedString, for: .normal)
            
            self.contentEdgeInsets = UIEdgeInsets(
                top: verticalPadding,
                left: horizontalPadding,
                bottom: verticalPadding,
                right: horizontalPadding
            )
            
            if isCapsule {
                self.layer.cornerRadius = self.frame.height / 2
                self.clipsToBounds = true
            }
        }
    }
}
