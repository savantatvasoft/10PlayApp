//
//  TopPopupView.swift
//  10PlayApp
//
//  Created by savan soni on 10/04/26.
//

import UIKit

class TopPopupView: UIView {
    var intrinsicHeight: CGFloat = 280
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TopPopupView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
