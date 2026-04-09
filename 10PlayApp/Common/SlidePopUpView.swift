import UIKit

enum SlideDirection: String {
    case top, bottom, left, right
}

@IBDesignable
class SlidePopUpView: UIView {
    
    @IBInspectable var entryDirection: String = "bottom"
    @IBInspectable var exitDirection: String = "bottom"
    @IBInspectable var animationDuration: Double = 0.5
    @IBInspectable var shouldAutoCapWidth: Bool = true
    
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
        
        if shouldAutoCapWidth {
            updateFrameForOrientation(in: parentView)
        }
        
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
        if self.frame.width > 0, self.frame.width < parent.bounds.width {
            return
        }
        let screenWidth = parent.bounds.width
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
