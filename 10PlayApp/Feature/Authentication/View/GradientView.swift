////
////  GradientView.swift
////  10PlayApp
////
////  Created by savan soni on 30/03/26.
////
//
//import UIKit
//
//@IBDesignable
//class GradientView: UIView {
//
//    // MARK: - Inspectable Properties
//
//    @IBInspectable var topColor: UIColor = UIColor.black {
//        didSet { updateGradient() }
//    }
//
//    @IBInspectable var bottomColor: UIColor = UIColor.black {
//        didSet { updateGradient() }
//    }
//
//    // Top = 1.0 → solid black at top
//    @IBInspectable var topAlpha: CGFloat = 1.0 {
//        didSet { updateGradient() }
//    }
//
//    // Bottom = 0.0 → transparent, map shows at bottom
//    @IBInspectable var bottomAlpha: CGFloat = 0.0 {
//        didSet { updateGradient() }
//    }
//
//    // MARK: - Private
//
//    private let gradientLayer = CAGradientLayer()
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGradient()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupGradient()
//    }
//
//    // MARK: - Setup
//
//    private func setupGradient() {
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top
//        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0) // Bottom
//        gradientLayer.locations  = [0.0, 1.0]
//        layer.insertSublayer(gradientLayer, at: 0)
//        updateGradient()
//    }
//
//    private func updateGradient() {
//        gradientLayer.colors = [
//            topColor.withAlphaComponent(topAlpha).cgColor,      // solid black on top
//            bottomColor.withAlphaComponent(bottomAlpha).cgColor // transparent at bottom
//        ]
//        setNeedsDisplay()
//    }
//
//    // MARK: - Layout
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//
//    // MARK: - IBDesignable live render
//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        setupGradient()
//        updateGradient()
//    }
//}


import UIKit

@IBDesignable
class GradientView: UIView {

    // MARK: - Inspectable Properties
    @IBInspectable var topColor: UIColor = .black { didSet { updateGradient() } }
    @IBInspectable var middleColor: UIColor = .darkGray { didSet { updateGradient() } }
    @IBInspectable var bottomColor: UIColor = .clear { didSet { updateGradient() } }

    @IBInspectable var topAlpha: CGFloat = 1.0 { didSet { updateGradient() } }
    @IBInspectable var middleAlpha: CGFloat = 0.5 { didSet { updateGradient() } }
    @IBInspectable var bottomAlpha: CGFloat = 0.0 { didSet { updateGradient() } }
    
    // New: Adjust where the middle color sits (0.0 to 1.0)
    @IBInspectable var middleLocation: CGFloat = 0.5 { didSet { updateGradient() } }

    // New: Toggle between Vertical and Horizontal
    @IBInspectable var isHorizontal: Bool = false { didSet { updateGradient() } }

    private let gradientLayer = CAGradientLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }

    private func updateGradient() {
        // 1. Setup Directions
        if isHorizontal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Left
            gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.5) // Right
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top
            gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0) // Bottom
        }

        // 2. Setup 3-Color Array
        gradientLayer.colors = [
            topColor.withAlphaComponent(topAlpha).cgColor,
            middleColor.withAlphaComponent(middleAlpha).cgColor,
            bottomColor.withAlphaComponent(bottomAlpha).cgColor
        ]

        // 3. Setup Locations
        gradientLayer.locations = [0.0, middleLocation as NSNumber, 1.0]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateGradient()
    }
}
