//
//  SliderMenu.swift
//  10PlayApp
//
//  Created by savan soni on 02/04/26.
//

import UIKit

class SliderMenu: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userSupportLabel: UILabel!
    
    @IBOutlet weak var supportView: UIView!
    
    
    private let drawerWidth: CGFloat = 250
    private var isPresented = false
    
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
        Bundle.main.loadNibNamed("SliderMenu", owner: self, options: nil)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(contentView)
        contentView.frame = CGRect(x: -drawerWidth, y: 0, width: drawerWidth, height: UIScreen.main.bounds.height)
        contentView.autoresizingMask = [.flexibleHeight]
        contentView.clipsToBounds = false
        
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(hide))
        outsideTap.cancelsTouchesInView = false
        outsideTap.delegate = self
        self.addGestureRecognizer(outsideTap)
        
//        homeButton.setStyle(weight: .extraBold, size: 20)
//        accountButton.setStyle(weight: .extraBold, size: 20)
//        contactButton.setStyle(weight: .extraBold, size: 20)
        
//        userSupportLabel.font = AppFont.get(.regular, size: 14)
    }
    
    func show(in parentView: UIView) {
        guard !isPresented else { return }
        isPresented = true
        self.frame = parentView.bounds
        self.alpha = 1.0
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if self.superview == nil {
            parentView.addSubview(self)
        }
        
        parentView.bringSubviewToFront(self)
        contentView.frame = CGRect(x: -drawerWidth, y: 0, width: drawerWidth, height: parentView.bounds.height)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
            self.contentView.frame.origin.x = 0
        })
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.contentView.frame.origin.x = -self.drawerWidth
        }) { _ in
            self.isPresented = false
            self.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        return point.x > drawerWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size = self.superview?.bounds.size ?? self.bounds.size
        let currentX = contentView.frame.origin.x
        contentView.frame = CGRect(x: currentX, y: 0, width: drawerWidth, height: self.bounds.height)
    }
}
