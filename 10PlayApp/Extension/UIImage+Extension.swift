//
//  UIImage+Extension.swift
//  10PlayApp
//
//  Created by savan soni on 09/04/26.
//

import Foundation
import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }.withRenderingMode(self.renderingMode)
    }
}
