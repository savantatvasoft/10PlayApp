//
//  ForgotPasswordPopUp.swift
//  10PlayApp
//
//  Created by savan soni on 30/03/26.
//


import UIKit

class ForgotPasswordPopUp: SlidePopUpView {
    
    // MARK: - Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var textFieldContainer: UIView!
    var onConfirm: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailTextField.delegate = self
        setupUI()
        updateButtonState(isActive: false)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        headerLabel.font = AppFont.get(.bold, size: 16)
        headerLabel.addCharacterSpacing(kernValue: 1.5)
        emailTextField.font = AppFont.get(.regular, size: 16)
        
        emailLabel.font = AppFont.get(.extraBold, size: 13)
        emailLabel.textColor = .darkGray
        emailTextField.font = AppFont.get(.regular, size: 14.5)
        cancelButton.setStyle(weight: .extraBold, size: 16, isCapsule: false, kern: 1.5)
        okButton.setStyle(weight: .extraBold, size: 16, horizontalPadding: 20, verticalPadding: 20 ,isCapsule: false, kern: 1.5)
    }
    
    private func updateButtonState(isActive: Bool) {
    }
        @IBAction func cancelPressed(_ sender: UIButton) {
            self.dismiss()
        }
        
        @IBAction func okPressed(_ sender: UIButton) {
            let email = emailTextField.text ?? ""
            onConfirm?(email)
            self.dismiss()
        }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordPopUp: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
