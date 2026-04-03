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
    
    private let bottomBorder = CALayer()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Lifecycle
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
        titleLabel.font = AppFont.get(.regular, size: 13)
        mainView.clipsToBounds = false
        
        // Ensure the field starts as non-editable
        titleLabel.isUserInteractionEnabled = false
    }

    func configure(title: String,
                   value: String?,
                   placeholder: String = "",
                   isEditable: Bool = true,
                   isPassword: Bool = false) {
        
        topLabel.text = title.uppercased()
        titleLabel.text = value
        titleLabel.placeholder = placeholder
        titleLabel.isSecureTextEntry = isPassword
       
    }

    // MARK: - Actions
    @IBAction func onPressRigthIcon(_ sender: UIButton) {
        titleLabel.isUserInteractionEnabled = true
        titleLabel.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Layout
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
