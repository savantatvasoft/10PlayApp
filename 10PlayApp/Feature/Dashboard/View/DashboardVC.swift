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
//        KeychainHelper.shared.delete(for: .apiKey)
//        KeychainHelper.shared.delete(for: .userId)
        setupDashboardLabel()
        setupLogoutButton()
    }
    
    
    private func setupLogoutButton() {
            let logoutButton = UIButton(type: .system)
            logoutButton.setTitle("LOGOUT", for: .normal)
            
            // Use your AppFont and setStyle if available, otherwise standard styling
            logoutButton.titleLabel?.font = AppFont.get(.bold, size: 16)
            logoutButton.setTitleColor(.white, for: .normal)
            logoutButton.backgroundColor = UIColor(named: "RedColor") ?? .red
            logoutButton.layer.cornerRadius = 8
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            
            logoutButton.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
            
            view.addSubview(logoutButton)
            
            // Positioning the button at the bottom
            NSLayoutConstraint.activate([
                logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                logoutButton.widthAnchor.constraint(equalToConstant: 120),
                logoutButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }

        @objc private func onLogout() {
            // 1. Clear Session Data
            KeychainHelper.shared.delete(for: .apiKey)
            
            // 2. Note: We DO NOT delete .userId here because we need it for future Biometric logins!
            
            // 3. Clear Login Preference
            UserDefaults.standard.set(false, forKey: "kKEY_LOGIN_PREFS")
            resetToLogin()
            // 4. Return to Login Screen (AuthenticationVC)
            // If your Login screen is the root, you can dismiss or pop
        }
    
    private func resetToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authVC = storyboard.instantiateViewController(withIdentifier: "AuthenticationVCID") as? AuthenticationVC else { return }
        
        // Wrap in NavigationController if your app uses one
        let navVC = UINavigationController(rootViewController: authVC)
        navVC.isNavigationBarHidden = true // Match your cinematic style
        
        // Get the window and perform a smooth transition
        if let window = view.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                window.rootViewController = navVC
            }, completion: nil)
        }
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
