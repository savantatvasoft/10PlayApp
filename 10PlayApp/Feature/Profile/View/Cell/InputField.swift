//
//  InputField.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class InputField: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightSwitch: UISwitch!
    
    var text: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    private let bottomBorder = CALayer()
    var onToggleChanged: ((Bool) -> Void)?
    var onEdit: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @IBAction func onToggleAction(_ sender: UISwitch) {
        onToggleChanged?(sender.isOn)
    }
    
    @IBAction func onPressRigthIcon(_ sender: UIButton) {
        titleLabel.isUserInteractionEnabled = true
        titleLabel.becomeFirstResponder()
        onEdit?("PASSWORD")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.layoutIfNeeded()
        
        let borderHeight: CGFloat = 1.0
        bottomBorder.frame = CGRect(
            x: 0,
            y: mainView.frame.height - borderHeight,
            width: mainView.frame.width,
            height: borderHeight
        )
    }
}


extension InputField {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InputField", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        titleLabel.delegate = self
        setupStyle()
    }
     
    private func setupStyle() {
        bottomBorder.backgroundColor = UIColor.systemGray4.cgColor
        mainView.layer.addSublayer(bottomBorder)
        
        topLabel.font = AppFont.get(.extraBold, size: 13)
        titleLabel.font = AppFont.get(.regular, size: 14)
        mainView.clipsToBounds = false
        titleLabel.isUserInteractionEnabled = false
    }
    
    func configure(title: String,
                   value: String?,
                   placeholder: String = "",
                   isEditable: Bool = true,
                   isPassword: Bool = false,
                   showToggle: Bool = false,
                   toggleState: Bool = false) {
        
        topLabel.text = title.uppercased()
        titleLabel.text = value
        titleLabel.placeholder = placeholder
        titleLabel.isSecureTextEntry = isPassword

        if showToggle {
            rightSwitch.isHidden = false
            rightButton.isHidden = true
            rightSwitch.isOn = toggleState
            titleLabel.isUserInteractionEnabled = false
        } else {
            rightSwitch.isHidden = true
            rightButton.isHidden = !isEditable
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
