//
//  UIView+Extension.swift
//  10PlayApp
//
//  Created by savan soni on 30/03/26.
//

import UIKit

@IBDesignable
extension UIView {
    
    // MARK: - Find First Responder
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        for subview in subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
    
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // MARK: - Border Width
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // MARK: - Border Color
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { layer.shadowColor.map { UIColor(cgColor: $0) } }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    
    var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder?.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    
      func bounce(completion: @escaping () -> Void) {
          
          // Step 1: animate down
          UIView.animate(withDuration: 0.1,
                         delay: 0,
                         options: [.curveEaseInOut, .allowUserInteraction],
                         animations: {
              self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
          }) { _ in
              
              // Step 2: spring back
              UIView.animate(withDuration: 0.3,
                             delay: 0,
                             usingSpringWithDamping: 0.4,
                             initialSpringVelocity: 4,
                             options: [.allowUserInteraction],
                             animations: {
                  self.transform = .identity
              }) { _ in
                  completion()
              }
          }
      }
    
}
