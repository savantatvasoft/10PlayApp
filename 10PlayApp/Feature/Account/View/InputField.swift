//
//  InputField.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class InputField: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topLabel: UILabel!
 
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var rightButton: UIButton!
    
    
    @IBAction func onPressRigthIcon(_ sender: Any) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Load XIB
    private func commonInit() {
        Bundle.main.loadNibNamed("InputField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
