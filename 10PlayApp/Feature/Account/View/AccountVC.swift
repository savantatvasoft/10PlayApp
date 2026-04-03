//
//  AccountVC.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class AccountVC: BaseViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
        attachHeader(header)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    
}
