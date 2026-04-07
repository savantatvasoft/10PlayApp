//
//  DropDownContainer.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import UIKit

class DropDownContainer: UIView {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var rightIcon: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            let nib = UINib(nibName: "DropDownContainer", bundle: nil)
            let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            
            
            setUp()
        }
    
    func setUp() {
        if let image = rightIcon.image(for: .normal) {
            rightIcon.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        rightIcon.tintColor = .systemGray
        
        topLabel.font = AppFont.get(.extraBold, size: 14)
        titleLabel.font =  AppFont.get(.regular, size: 14)
    }
    
    func confirgure(label: String,title: String) {
        topLabel.text = label
        titleLabel.text = title
    }
    
    
    
    @IBAction func onPressRightIcon(_ sender: Any) {
        
    }
    
}
