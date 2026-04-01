//
//  ValidationMsgPopUp.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit

class ValidationMsgPopUp: SlidePopUpView {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        errorLabel.font = AppFont.get(.regular, size: 14.5)
        errorLabel.addCharacterSpacing(kernValue: 0.5)
        
        btnView.setStyle(weight: .extraBold, size: 15, horizontalPadding: 40, verticalPadding: 15, isCapsule: false, kern: 1.3)
        
        self.entryDirection = "top"
        self.exitDirection = "bottom"
    }
    
    func configure(with message: String, isSuccess: Bool = false) {
            errorLabel.text = message
        let iconName = isSuccess ? "Ico_info" : "Ico_error"
            
        if iconName == "Ico_info" {
            if let iconImage = UIImage(named: iconName) {
                self.img.image = iconImage.withRenderingMode(.alwaysTemplate)
            }
            if let redColor = UIColor(named: "RedColor") {
                self.img.tintColor = redColor
            } else {
                self.img.tintColor = .systemRed
                print("⚠️ Warning: 'RedColor' asset not found, using fallback systemRed.")
            }
        }
        else {
            img.image = UIImage(named: iconName)
        }
           
    }
    @IBAction func onPressOk(_ sender: Any) {
        self.dismiss()
    }
}
