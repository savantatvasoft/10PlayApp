//
//  ValidationMsgPopUp.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit

class ValidationMsgPopUp: SlidePopUpView {
    
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
    
    func configure(with message: String) {
        errorLabel.text = message
    }
    
    @IBAction func onPressOk(_ sender: Any) {
        self.dismiss()
    }
}
