//
//  ViewController.swift
//  10PlayApp
//
//  Created by MACM72 on 30/03/26.
//

import UIKit
import Combine

class AuthenticationVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordVisibilityIcon: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotTextView: UIButton!
    @IBOutlet weak var biometericIcon: UIImageView!
    
    private var keyboardManager: KeyboardManager?
    var loadingOverlay: LoadingOverlayView?
    private let viewModel = AuthenticationVM()
    private var cancellables = Set<AnyCancellable>()
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManager = KeyboardManager(scrollView: scrollView, viewController: self)
        setupFonts()
        setupPasswordToggle()
        bindViewModel()
        setupBiometricInteraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager?.observeKeyboard()
        let shouldShowIcon = PreferenceManager.isBiometricEnabled
        biometericIcon.isHidden = !shouldShowIcon
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.stopObserving()
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
            Task {
                let isSuccess = await viewModel.performLogin()
                if isSuccess {
                    self.performSegue(withIdentifier: "DashboardVCID", sender: self)
                }
            }
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
        
        forgotView.onConfirm = { [weak self] email in
            guard let self = self else { return }
            Task {
                await self.viewModel.performForgotPassword(validEmail: email)
            }
        }
        
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
            .sink { [weak self] msg in
                if let error = msg {
                    self?.showValidationPopup(message: error, isSuccess: false)
                }
            }
            .store(in: &cancellables)
        
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.showLoader()
                } else {
                    self.hideLoader()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$success
            .receive(on: RunLoop.main)
            .sink { [weak self] successMessage in
                if let msg = successMessage {
                    self?.showValidationPopup(message: msg, isSuccess: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.biometricLoginResult
                .receive(on: RunLoop.main)
                .sink { [weak self] isSuccess in
                    if isSuccess {
                        self?.performSegue(withIdentifier: "DashboardVCID", sender: self)
                    }
                }
                .store(in: &cancellables)
    }
    
    private func setupBiometricInteraction() {
        biometericIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBiometricTap))
        biometericIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBiometricTap() {
        biometericIcon.bounce { [weak self] in
                Task {
                    await self?.viewModel.handleBiometricLogin()
                }
            }
    }
    
    private func showValidationPopup(message: String, isSuccess: Bool) {
        ValidationMsgPopUp.show(on: self, message: message,isSucsess: isSuccess)
    }
    
    private func setupFonts() {
        emailLabel.font = AppFont.get(.extraBold, size: 12)
        emailLabel.addCharacterSpacing(kernValue: 1.5)
        passwordLabel.font = AppFont.get(.extraBold, size: 12)
        passwordLabel.addCharacterSpacing(kernValue: 1.5)
        email.font = AppFont.get(.regular, size: 16)
        password.font = AppFont.get(.regular, size: 16)
        
        loginButton.setStyle(weight: .bold, size: 14, horizontalPadding: 20, verticalPadding: 10, kern: 1.5)
        forgotTextView.setStyle(weight: .bold, size: 12, kern: 1.5)
    }
    
    private func setupPasswordToggle() {
        password.isSecureTextEntry = true
        passwordVisibilityIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        passwordVisibilityIcon.addGestureRecognizer(tapGesture)
    }
    
    private func showLoader() {
        guard loadingOverlay == nil else { return }
        
        let overlay = LoadingOverlayView(message: "AUTHENTICATION",isTransparent: false)
        overlay.frame = self.view.bounds
        overlay.alpha = 0
        
        self.view.addSubview(overlay)
        self.loadingOverlay = overlay
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
        }
    }
    
    private func hideLoader() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingOverlay?.alpha = 0
        }) { _ in
            self.loadingOverlay?.removeFromSuperview()
            self.loadingOverlay = nil
        }
    }
    
}
