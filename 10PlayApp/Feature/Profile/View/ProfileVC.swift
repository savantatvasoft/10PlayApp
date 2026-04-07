//
//  AccountVC.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit
import Combine

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var header: Header!
    @IBOutlet weak var firstName: InputField!
    @IBOutlet weak var lastName: InputField!
    @IBOutlet weak var phoneNumber: InputField!
    @IBOutlet weak var email: InputField!
    @IBOutlet weak var password: InputField!
    @IBOutlet weak var biometric: InputField!
    @IBOutlet weak var directional: InputField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var viewModel = ProfileVM()
    private var cancellables = Set<AnyCancellable>()
    private var keyboardManager: KeyboardManager?
    
    override func viewDidLoad() {
        print("Biometric Enabled:", PreferenceManager.isBiometricEnabled)
        super.viewDidLoad()
        keyboardManager = KeyboardManager(scrollView: scrollView, viewController: self)
        
        bindViewModel()
        setupFields()
        attachHeader(header)
        setupBottomViewStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager?.observeKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shadowRect = bottomView.bounds
        bottomView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.stopObserving()
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        let nom = lastName.text ?? ""
        let prenom = firstName.text ?? ""
        let phone = phoneNumber.text ?? ""
        let mail = email.text ?? ""

        let zip = "75001"
        Task {
            let isSuccess = await viewModel.updateProfile(
                nom: nom,
                prenom: prenom,
                telephone: phone,
                codePostal: zip,
                email: mail
            )
            
            if isSuccess {
                print("✅ Profile updated successfully in UI")
               
            }
        }
    }}

extension ProfileVC {
    
    private func setupFields() {
        
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        header.configure(
            headerTitle: "account_title".localized,
            rightIcon: UIImage(named: "ic_10_play_white")
        )

        directional.titleLabel.font = AppFont.get(.regular, size: 10)
        directional.configure(
            title: "directional_title".localized,
            value: "directional_label".localized,
            showToggle: true,
            toggleState: true
        )
        
        biometric.titleLabel.isHidden = true
        let isCurrentlyActive = PreferenceManager.isBiometricEnabled

        biometric.configure(
            title: "biometric_title".localized,
            value: nil,
            showToggle: true,
            toggleState: isCurrentlyActive
        )
        
        saveBtn.setStyle(weight: .extraBold, size: 13,horizontalPadding: 30,verticalPadding: 10)
    }
    
    private func setupBottomViewStyle() {
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10.0
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomView.layer.masksToBounds = false
        bottomView.clipsToBounds = false
    }
    
    func bindViewModel() {
        
        password.onEdit = { [weak self] _ in
                self?.showUpdatePasswordPopup()
        }
        
        biometric.onToggleChanged = { [weak self] isOn in
            if isOn {
                self?.biometric.rightSwitch.setOn(false, animated: false)
                self?.showValidationPopup()
            } else {
                PreferenceManager.isBiometricEnabled = false
            }
        }
        
        viewModel.$userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                        guard let self = self, let user = user else { return }
                        self.populateUI(with: user)
                    }
            .store(in: &cancellables)
      
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self, let message = message else { return }
                ValidationMsgPopUp.show(on: self, message: message , isSucsess: false)
                self.viewModel.errorMessage = nil
            }
            .store(in: &cancellables)

        viewModel.$successMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self, let message = message else { return }
                ValidationMsgPopUp.show(on: self, message: message,isSucsess: true,iconName: "Ico_success")
                self.viewModel.successMessage = nil
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.toggleLoader(show: isLoading, isTransparent: true)
            }
            .store(in: &cancellables)
        
    }
    
    private func populateUI(with user: UserData) {
        let cachedPassword = KeychainHelper.shared.read(for: .userPassword)
            firstName.configure(title: "first_name_title".localized, value: user.prenom)
            lastName.configure(title: "last_name_title".localized, value: user.nom)
            phoneNumber.configure(title: "phone_number_title".localized, value: user.telephone)
            email.configure(title: "email_title".localized, value: user.login, isEditable: false)
            password.configure(title: "password_title".localized, value: "\(cachedPassword!)", isPassword: true)
        }
    
    private func showValidationPopup() {
        guard let popup = Bundle.main.loadNibNamed("ForgotPasswordPopUp", owner: nil)?.first as? ForgotPasswordPopUp else { return }
        
        // 1. Configure UI
        popup.headerLabel.text = "10Play.io"
        popup.headerLabel.font = AppFont.get(.bold, size: 16)
        
        // Use localized string or fallback text
        let message = "account_biometric_ask".localized
        popup.emailLabel.text = message
        popup.emailLabel.font = AppFont.get(.regular, size: 14)
        
        // 2. Multiline Fix
        popup.emailLabel.numberOfLines = 0
        popup.emailLabel.lineBreakMode = .byWordWrapping
        
        // 3. Component Visibility
        popup.textFieldContainer.isHidden = true
        popup.emailTextField.isHidden = true
        
        // 4. Layout & Height Calculation
        let popupWidth = self.view.frame.width * 0.7
        popup.emailLabel.preferredMaxLayoutWidth = popupWidth - 20 // Subtracting internal padding
        
        popup.setNeedsLayout()
        popup.layoutIfNeeded()
        
        let targetSize = CGSize(width: popupWidth, height: UIView.layoutFittingCompressedSize.height)
        let dynamicSize = popup.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        popup.frame = CGRect(x: 0, y: 0, width: popupWidth, height: dynamicSize.height + 10)
        
        popup.entryDirection = "top"
        popup.exitDirection = "bottom"
        
        // 6. PreferenceManager Logic
        popup.onConfirm = { [weak self] _ in
            
            print("onConfirm")
            PreferenceManager.hasAskedBiometric = true
            PreferenceManager.isBiometricEnabled = true
            // Sync UI switch
            print("Biometric Enabled onConfirm:", PreferenceManager.isBiometricEnabled)
            self?.biometric.configure(
                title: "biometric_title".localized,
                value: nil,
                showToggle: true,
                toggleState: true
            )
        }
        
        popup.onCancel = {
            PreferenceManager.hasAskedBiometric = false
            PreferenceManager.isBiometricEnabled = false
            
            self.biometric.configure(
                title: "biometric_title".localized,
                value: nil,
                showToggle: true,
                toggleState: false
            )
        }
        
        popup.show(in: self.view)
    }
    
}


// MARK: Update Password
extension ProfileVC {
    
    private func showUpdatePasswordPopup() {
        
        guard !PreferenceManager.hasAskedBiometric && PreferenceManager.isHardwareReady else {
            return
        }
        
        guard let passwordPopup = Bundle.main.loadNibNamed("UpdatePasswordPopUp", owner: nil)?.first as? UpdatePasswordPopUp else { return }
        
        let popupWidth = self.view.frame.width * 0.8
        passwordPopup.frame = CGRect(x: 0, y: 0, width: popupWidth, height: 310)
        passwordPopup.entryDirection = "bottom"
        passwordPopup.exitDirection = "bottom"
        
        passwordPopup.configure(
            title: "password_title".localized,
            currentPwdLabel: "current_password_title".localized,
            newPwdLabel: "new_password_title".localized,
            confirmPwdLabel: "confirm_password_title".localized
        )
        
        passwordPopup.onConfirm = { [weak self] current, new, confirm in
            guard let self = self else { return }
            self.handlePasswordUpdate(current: current, new: new, confirm: confirm)
        }
    
        passwordPopup.show(in: self.view)
    }
    
    private func handlePasswordUpdate(current: String, new: String, confirm: String) {
        Task {
            let isSuccess = await self.viewModel.updatePassword(
                current: current,
                new: new,
                confirm: confirm
            )
            
            if isSuccess {
                self.password.configure(
                    title: "password_title".localized,
                    value: new,
                    isPassword: true
                )
                print("✅ UI and Keychain synchronized successfully.")
            }
        
        }
    }
}
