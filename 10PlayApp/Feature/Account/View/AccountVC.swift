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
        
        // Last Name
        lastName.configure(
            title: "last_name_title".localized,
            value: "Kruti"
        )
        
        // Phone Number
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
        
    }
    
    
}
