//
//  UITextField+Extension.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
