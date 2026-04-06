//
//  AccountVC.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class AccountVC: BaseViewController {
    
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
    
    private var keyboardManager: KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManager = KeyboardManager(scrollView: scrollView, viewController: self)
        
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
    
}

extension AccountVC {
    
    private func setupFields() {
        
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        
        header.configure(
            headerTitle: "account_title".localized,
            rightIcon: UIImage(named: "ic_10_play_white")
        )
        
        firstName.configure(
            title: "first_name_title".localized,
            value: "shahh"
        )
        
        lastName.configure(
            title: "last_name_title".localized,
            value: "Kruti"
        )
        
        phoneNumber.configure(
            title: "phone_number_title".localized,
            value: "9428151966"
        )
        
        email.rightButton.isHidden = true
        email.configure(
            title: "email_title".localized,
            value: "kruti.shah@yopmail.com",
            isEditable: false
        )
        
        password.configure(
            title: "password_title".localized,
            value: "12345678",
            isPassword: true
        )
        
        directional.titleLabel.font = AppFont.get(.regular, size: 11)
        
        directional.configure(
            title: "directional_title".localized,
            value: "directional_label".localized,
            showToggle: true,
            toggleState: true
        )
        
        biometric.titleLabel.isHidden = true
        biometric.configure(
            title: "biometric_title".localized,
            value: nil,
            showToggle: true,
            toggleState: false
        )
        
        saveBtn.setStyle(weight: .extraBold, size: 13,horizontalPadding: 30,verticalPadding: 10)
        
        password.onEdit = { [weak self] _ in
            guard let self = self else { return }
            guard let passwordPopup = Bundle.main.loadNibNamed("UpdatePasswordPopUp", owner: nil)?.first as? UpdatePasswordPopUp else { return }

            let popupWidth = self.view.frame.width * 0.8
            passwordPopup.frame = CGRect(x: 0, y: 0, width: popupWidth, height: 360)
            
            passwordPopup.entryDirection = "bottom"
            passwordPopup.exitDirection = "bottom"
            passwordPopup.configure(
                title: "password_title".localized,
                currentPwdLabel: "current_password_title".localized,
                newPwdLabel: "new_password_title".localized,
                confirmPwdLabel: "confirm_password_title".localized
            )
            passwordPopup.show(in: self.view)
        }
    }
    
    private func setupBottomViewStyle() {
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10.0
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -5)
        
        bottomView.layer.masksToBounds = false
        bottomView.clipsToBounds = false
    }
    
}
