//
//  Header.swift
//  10PlayApp
//
//  Created by savan soni on 01/04/26.
//

import UIKit

class Header: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var centerTitle: UILabel!
    @IBOutlet weak var centerIcon: UIImageView!
    @IBOutlet weak var leftImage: UIButton!
    @IBOutlet weak var rightImage: UIButton!
    
    // MARK: - Interaction Closures
    var onLeftTap: (() -> Void)?
    var onRightTap: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Header", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            print("Error: Could not load Header XIB")
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        centerTitle.isHidden = true
        centerTitle.font =  AppFont.get(.extraBold, size: 16)
        addSubview(view)
    }
    
    // MARK: - IBActions (Button Triggers)
    @IBAction func onPressLeft(_ sender: Any) {
        // Trigger immediately for zero delay
        onLeftTap?()
    }
    
    @IBAction func onPressRight(_ sender: Any) {
        onRightTap?()
    }
    
    // MARK: - Configuration
    func configure(headerTitle: String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        
        if !headerTitle.isEmpty {
            centerTitle.isHidden = false
            centerTitle.text = headerTitle
        }
        
        // Use setImage for buttons instead of .image
        if let left = leftIcon {
            leftImage.setImage(left, for: .normal)
        }
        if let right = rightIcon {
            rightImage.setImage(right, for: .normal)
        }
    }
}
