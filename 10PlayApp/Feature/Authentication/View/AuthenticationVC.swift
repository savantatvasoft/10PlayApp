//
//  ViewController.swift
//  10PlayApp
//
//  Created by MACM72 on 30/03/26.
//

import UIKit
import Combine

class AuthenticationVC: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordVisibilityIcon: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotTextView: UIButton!
    
    private let viewModel = AuthenticationVM()
    private var cancellables = Set<AnyCancellable>()
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFonts()
        setupPasswordToggle()
        bindViewModel()
    }
    
    // MARK: - Navigation & Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let popUp = self.view.subviews.first(where: { $0 is ForgotPasswordPopUp }) as? ForgotPasswordPopUp {
            popUp.dismiss {
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.onPressForgot(UIButton())
                }
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        viewModel.loginTrigger.send()
        if viewModel.errorMessage == nil {
            print("🚀 Success! Attempting login for: \(viewModel.emailText)")
        }
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        password.isSecureTextEntry = !isPasswordVisible
        let iconName = isPasswordVisible ? "visibility" : "visibility_off"
        passwordVisibilityIcon.image = UIImage(named: iconName)
        
        let currentText = password.text
        password.text = nil
        password.text = currentText
        password.becomeFirstResponder()
    }
    
    @IBAction func onPressForgot(_ sender: Any) {
        guard let forgotView = Bundle.main.loadNibNamed("ForgotPasswordPopUp", owner: nil)?.first as? ForgotPasswordPopUp else { return }
        let popupWidth = self.view.frame.width * 0.7
        forgotView.frame = CGRect(x: 0, y: 0, width: popupWidth, height: 180)
        forgotView.entryDirection = "bottom"
        forgotView.exitDirection = "bottom"
        forgotView.show(in: self.view)
    }
}



extension AuthenticationVC {

    private func bindViewModel() {
        email.textPublisher
            .assign(to: \.emailText, on: viewModel)
            .store(in: &cancellables)
        
        password.textPublisher
            .assign(to: \.passwordText, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { msg in
                if let error = msg {
                    guard let popup = Bundle.main.loadNibNamed("ValidationMsgPopUp", owner: nil)?.first as? ValidationMsgPopUp else { return }
                            
                            let popupWidth = self.view.frame.width * 0.75
                            popup.frame = CGRect(x: 0, y: 0, width: popupWidth, height: 180)
                            
                            popup.configure(with: error)
                            
                            // Use the inherited show method from SliderPopView
                            popup.show(in: self.view)
                }
            }
            .store(in: &cancellables)
        
        viewModel.isLoginEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                print("isLoginEnabled listener : \(isEnabled)")
            }
            .store(in: &cancellables)
    }
    
    private func setupFonts() {
        emailLabel.font = AppFont.get(.extraBold, size: 14)
        emailLabel.addCharacterSpacing(kernValue: 1.5)
        passwordLabel.font = AppFont.get(.extraBold, size: 14)
        passwordLabel.addCharacterSpacing(kernValue: 1.5)
        email.font = AppFont.get(.medium, size: 14)
        password.font = AppFont.get(.medium, size: 14)
        
        loginButton.setStyle(weight: .bold, size: 16, horizontalPadding: 20, verticalPadding: 10, kern: 1.5)
        forgotTextView.setStyle(weight: .bold, size: 14, kern: 1.5)
    }
    
    private func setupPasswordToggle() {
        password.isSecureTextEntry = true
        passwordVisibilityIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        passwordVisibilityIcon.addGestureRecognizer(tapGesture)
    }
    
}
