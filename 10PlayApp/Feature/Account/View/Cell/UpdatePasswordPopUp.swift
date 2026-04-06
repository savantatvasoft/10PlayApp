//
//  UpatePasswordPopUp.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class UpdatePasswordPopUp: SlidePopUpView {

    // MARK: - Outlets
    @IBOutlet weak var topTtile: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdTexField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var onConfirm: ((_ current: String, _ new: String, _ confirm: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [firstTextField, secondTextField, thirdTexField].forEach { $0?.delegate = self }
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        topTtile.font = AppFont.get(.bold, size: 14)
        topTtile.addCharacterSpacing(kernValue: 1.2)
        
        // Labels & TextFields
        [firstLabel, secondLabel, thirdLabel].forEach {
            $0?.font = AppFont.get(.extraBold, size: 12)
            $0?.textColor = .darkGray
        }
        
        [firstTextField, secondTextField, thirdTexField].forEach {
            $0?.font = AppFont.get(.regular, size: 14.5)
            $0?.isSecureTextEntry = true
        }
        
        // Button Styles
        cancelButton?.setStyle(weight: .extraBold, size: 14, isCapsule: false, kern: 1.3)
        updateButton?.setStyle(weight: .extraBold, size: 14, horizontalPadding: 20, verticalPadding: 20, isCapsule: false, kern: 1.3)
    }
    
    // MARK: - Configuration
    func configure(title: String, currentPwdLabel: String, newPwdLabel: String, confirmPwdLabel: String) {
        topTtile.text = title.uppercased()
        firstLabel.text = currentPwdLabel
        secondLabel.text = newPwdLabel
        thirdLabel.text = confirmPwdLabel
    }
    
    // MARK: - Actions
    @IBAction func cancelPressed(_ sender: UIButton) {
        Task { @MainActor in
            sender.bounce { [weak self] in
                print("canclele")
                self?.dismiss()
            }
        }
    }

    @IBAction func updatePressed(_ sender: UIButton) {
        Task { @MainActor in
            sender.bounce { [weak self] in
                
                print("sssssss")
                
                guard let self = self else { return }
                let current = self.firstTextField.text ?? ""
                let new = self.secondTextField.text ?? ""
                let confirm = self.thirdTexField.text ?? ""
                self.onConfirm?(current, new, confirm)
                self.dismiss()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension UpdatePasswordPopUp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstTextField {
            secondTextField.becomeFirstResponder()
        } else if textField == secondTextField {
            thirdTexField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
