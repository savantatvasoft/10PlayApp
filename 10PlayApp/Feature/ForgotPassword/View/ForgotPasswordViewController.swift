//
//  ForgotPasswordViewController.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    private var popupView: ForgotPasswordPopUp?
    private var centerYConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.alpha = 0
        setupPopup()
    }
    
    private func setupPopup() {
        guard let customPopUp = Bundle.main.loadNibNamed("ForgotPasswordPopUp", owner: nil)?.first as? ForgotPasswordPopUp else { return }
        
        self.popupView = customPopUp
        view.addSubview(customPopUp)
        customPopUp.translatesAutoresizingMaskIntoConstraints = false
        
        // 1. Initial State: Position it completely off-screen using the view's height
        // We use a high constant to ensure it starts way below the visible area
        centerYConstraint = customPopUp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1000)
        
        NSLayoutConstraint.activate([
            customPopUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Width Fix: Multiplier for portrait, max limit for landscape
            customPopUp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).withPriority(999),
            customPopUp.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            // Height Fix: Multiplier prevents the 'stretch' look on rotation
            customPopUp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            centerYConstraint!
        ])
        
        // 2. Immediate Layout: This removes the delay
        view.layoutIfNeeded()
        
        // 3. Trigger Slide-In immediately after layout
        animateIn()
    }
    
    private func animateIn() {
        // Move to center
        centerYConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction]) {
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissPopup() {
        // Slide out back to bottom
        centerYConstraint?.constant = 1000
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    // FIX: Ensure constraints update correctly when rotating
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.view.layoutIfNeeded()
        })
    }
}

// Helper to set priority inline
extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
