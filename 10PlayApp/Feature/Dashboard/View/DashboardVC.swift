//
//  DashboardVC.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Set background color (optional, so you can see the white text)
        view.backgroundColor = .black
        KeychainHelper.shared.delete(for: .apiKey)
//        KeychainHelper.shared.delete(for: .userId)
        setupDashboardLabel()
    }

    private func setupDashboardLabel() {
        let dashboardLabel = UILabel()
        dashboardLabel.text = "DASHBOARD"
        dashboardLabel.textColor = .white
        dashboardLabel.font = AppFont.get(.bold, size: 24)
        dashboardLabel.addCharacterSpacing(kernValue: 2.0)
        dashboardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Add to the view hierarchy
        view.addSubview(dashboardLabel)
        
        // 6. Set Constraints (Center X and Center Y)
        NSLayoutConstraint.activate([
            dashboardLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dashboardLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("PreferenceManager.hasAskedBiometric : \(PreferenceManager.hasAskedBiometric) and PreferenceManager.isHardwareReady \(PreferenceManager.isHardwareReady)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showValidationPopup()
    }
    
    private func showValidationPopup() {
        
        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else {
            
                return
        }
        
        guard let forgotView = Bundle.main.loadNibNamed("ForgotPasswordPopUp", owner: nil)?.first as? ForgotPasswordPopUp else { return }
        
        forgotView.headerLabel.text = "10Play.io"
        forgotView.headerLabel.textAlignment = .center
        forgotView.headerLabel.font = AppFont.get(.bold, size: 16)
        forgotView.emailLabel.numberOfLines = 0
        forgotView.emailLabel.lineBreakMode = .byWordWrapping
        forgotView.emailLabel.textAlignment = .left
        forgotView.emailLabel.text = "Do you want to enable biometric authentication?"
        forgotView.emailLabel.font = AppFont.get(.regular, size: 14)
        forgotView.emailLabel.addCharacterSpacing(kernValue: 1)
        forgotView.textFieldContainer.isHidden = true
        forgotView.emailTextField.isHidden = true
    
        let popupWidth = self.view.frame.width
        let targetSize = CGSize(width: popupWidth, height: UIView.layoutFittingCompressedSize.height)
        let dynamicSize = forgotView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        forgotView.frame = CGRect(x: 0, y: 0, width: popupWidth, height: dynamicSize.height + 40)
        
        forgotView.entryDirection = "bottom"
        forgotView.exitDirection = "bottom"
        forgotView.layoutIfNeeded()
        
        forgotView.onConfirm = { [weak self] _ in
            // Logic for YES (Oui)
            PreferenceManager.hasAskedBiometric = true
            PreferenceManager.isBiometricEnabled = true
        }
        
        forgotView.show(in: self.view)
    }
    
    @objc private func handleBiometricDecline() {
        PreferenceManager.hasAskedBiometric = true
        PreferenceManager.isBiometricEnabled = false
        // The popup will dismiss itself via its internal cancelPressed logic
    }
}
