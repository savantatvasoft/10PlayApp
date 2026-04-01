//
//  AppFont.swift
//  10PlayApp
//
//  Created by savan soni on 30/03/26.
//

import UIKit

enum RobotoWeight: String {
    case thin = "Thin"
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
    case semiBold = "SemiBold"
    case extraBold = "ExtraBold"
    case light = "Light"
}

struct AppFont {
//    static let family = "Roboto"
    static let family = "Gontserrat"
//    Gontserrat-Thin.ttf

    static func get(_ weight: RobotoWeight, size: CGFloat) -> UIFont {
        // Try the standard PostScript naming convention first
        let fullFontName = "\(family)-\(weight.rawValue)"
        
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        
        if weight == .regular, let fallback = UIFont(name: family, size: size) {
            return fallback
        }

        print("⚠️ Font View Error: \(fullFontName) not found. Using system font.")
        return UIFont.systemFont(ofSize: size)
    }
}
