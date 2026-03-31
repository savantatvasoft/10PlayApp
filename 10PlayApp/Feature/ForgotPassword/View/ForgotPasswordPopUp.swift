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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailTextField.delegate = self
        setupUI()
        updateButtonState(isActive: false)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        // 1. Set Font Families
        headerLabel.font = AppFont.get(.bold, size: 16)
        headerLabel.addCharacterSpacing(kernValue: 1.5)
        
        emailLabel.font = AppFont.get(.extraBold, size: 13)
        emailLabel.textColor = .darkGray
        emailTextField.font = AppFont.get(.regular, size: 14.5)
        cancelButton.setStyle(weight: .extraBold, size: 16, isCapsule: false, kern: 1.5)
        okButton.setStyle(weight: .extraBold, size: 16, horizontalPadding: 20, verticalPadding: 20 ,isCapsule: false, kern: 1.5)
    }
    
    // 3. Update Button State Logic
    private func updateButtonState(isActive: Bool) {
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func okPressed(_ sender: UIButton) {
        self.dismiss()
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordPopUp: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        // Activate if text is not empty (you can add regex here later)
        updateButtonState(isActive: !text.isEmpty)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
