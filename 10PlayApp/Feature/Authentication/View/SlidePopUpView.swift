////
////  SlidePopUpView.swift
////  10PlayApp
////
////  Created by savan soni on 30/03/26.
////
//
//import UIKit
//
//enum SlideDirection: String {
//    case top = "top"
//    case bottom = "bottom"
//    case left = "left"
//    case right = "right"
//}
//
//@IBDesignable
//class SlidePopUpView: UIView {
//    
//    @IBInspectable var entryDirection: String = "bottom"
//    @IBInspectable var exitDirection: String = "bottom"
//    @IBInspectable var animationDuration: Double = 0.5
//    
//    
//    private var backgroundOverlay: UIView?
//
//    // Convert the String back to our Enum safely
//    private var entry: SlideDirection {
//        return SlideDirection(rawValue: entryDirection.lowercased()) ?? .bottom
//    }
//    private var exit: SlideDirection {
//        return SlideDirection(rawValue: exitDirection.lowercased()) ?? .bottom
//    }
//
//    func show(in parentView: UIView) {
//        let overlay = UIView(frame: parentView.bounds)
//        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        overlay.alpha = 0
//        parentView.addSubview(overlay)
//        self.backgroundOverlay = overlay
//        
//        parentView.addSubview(self)
//        
//        // Final position setup
//        self.layoutIfNeeded()
//        self.center = parentView.center
//        
//        // Start from off-screen
//        setInitialPosition(parentBounds: parentView.bounds)
//        
//        UIView.animate(withDuration: animationDuration, delay: 0,
//                       usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4,
//                       options: .curveEaseOut, animations: {
//            self.center = parentView.center
//            overlay.alpha = 1
//        })
//    }
//    
//    func dismiss() {
//        guard let parentBounds = superview?.bounds else { return }
//        
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.setExitPosition(parentBounds: parentBounds)
//            self.backgroundOverlay?.alpha = 0
//        }) { _ in
//            self.backgroundOverlay?.removeFromSuperview()
//            self.removeFromSuperview()
//        }
//    }
//
//    private func setInitialPosition(parentBounds: CGRect) {
//        switch entry {
//        case .top:    self.frame.origin.y = -self.frame.height
//        case .bottom: self.frame.origin.y = parentBounds.height
//        case .left:   self.frame.origin.x = -self.frame.width
//        case .right:  self.frame.origin.x = parentBounds.width
//        }
//    }
//
//    private func setExitPosition(parentBounds: CGRect) {
//        switch exit {
//        case .top:    self.frame.origin.y = -self.frame.height
//        case .bottom: self.frame.origin.y = parentBounds.height
//        case .left:   self.frame.origin.x = -self.frame.width
//        case .right:  self.frame.origin.x = parentBounds.width
//        }
//    }
//}



import UIKit

enum SlideDirection: String {
    case top, bottom, left, right
}

@IBDesignable
class SlidePopUpView: UIView {
    
    @IBInspectable var entryDirection: String = "bottom"
    @IBInspectable var exitDirection: String = "bottom"
    @IBInspectable var animationDuration: Double = 0.5
    
    private var backgroundOverlay: UIView?
    private(set) var isPresented: Bool = false

    private var entry: SlideDirection {
        return SlideDirection(rawValue: entryDirection.lowercased()) ?? .bottom
    }
    private var exit: SlideDirection {
        return SlideDirection(rawValue: exitDirection.lowercased()) ?? .bottom
    }

    func show(in parentView: UIView) {
        isPresented = true
        
        let overlay = UIView(frame: parentView.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlay.alpha = 0
        parentView.addSubview(overlay)
        self.backgroundOverlay = overlay
        
        parentView.addSubview(self)
        
        // Fix for stretching: Cap the width for landscape
        updateFrameForOrientation(in: parentView)
        
        self.layoutIfNeeded()
        self.center = parentView.center
        setInitialPosition(parentBounds: parentView.bounds)
        
        UIView.animate(withDuration: animationDuration, delay: 0,
                       usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4,
                       options: .curveEaseOut, animations: {
            self.center = parentView.center
            overlay.alpha = 1
        })
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        guard let parentBounds = superview?.bounds else { return }
        isPresented = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.setExitPosition(parentBounds: parentBounds)
            self.backgroundOverlay?.alpha = 0
        }) { _ in
            self.backgroundOverlay?.removeFromSuperview()
            self.removeFromSuperview()
            completion?()
        }
    }

    // New helper to prevent stretching
    private func updateFrameForOrientation(in parent: UIView) {
        let screenWidth = parent.bounds.width
        // Cap width at 420 for landscape to prevent the 'stretch' look
        let targetWidth = min(screenWidth * 0.78, 420)
        self.frame.size.width = targetWidth
    }

    private func setInitialPosition(parentBounds: CGRect) {
        switch entry {
        case .top:    self.frame.origin.y = -self.frame.height
        case .bottom: self.frame.origin.y = parentBounds.height
        case .left:   self.frame.origin.x = -self.frame.width
        case .right:  self.frame.origin.x = parentBounds.width
        }
    }

    private func setExitPosition(parentBounds: CGRect) {
        switch exit {
        case .top:    self.frame.origin.y = -self.frame.height
        case .bottom: self.frame.origin.y = parentBounds.height
        case .left:   self.frame.origin.x = -self.frame.width
        case .right:  self.frame.origin.x = parentBounds.width
        }
    }
}
