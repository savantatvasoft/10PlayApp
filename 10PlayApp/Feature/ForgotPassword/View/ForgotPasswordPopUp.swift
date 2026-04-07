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
    var onCancel: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailTextField.delegate = self
        setupUI()
        updateButtonState(isActive: false)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        headerLabel.font = AppFont.get(.bold, size: 14)
        headerLabel.addCharacterSpacing(kernValue: 1.2)
        
        emailLabel.font = AppFont.get(.extraBold, size: 12)
        emailLabel.textColor = .darkGray
        emailTextField.font = AppFont.get(.regular, size: 14.5)
        cancelButton.setStyle(weight: .extraBold, size: 14, isCapsule: false, kern: 1.3)
        okButton.setStyle(weight: .extraBold, size: 14, horizontalPadding: 20, verticalPadding: 20 ,isCapsule: false, kern: 1.3)
    }
    
    private func updateButtonState(isActive: Bool) {
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        
        
        Task { @MainActor in
            sender.bounce { [weak self] in
                Task { @MainActor in
                    self?.onCancel?()
                    self?.dismiss()
                }
            }
        }
    }

    @IBAction func okPressed(_ sender: UIButton) {
        Task { @MainActor in
            
            sender.bounce { [weak self] in
                Task { @MainActor in
                    let email = self?.emailTextField.text ?? ""
                    self?.onConfirm?(email)
                    self?.dismiss()
                }
            }
        }
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
