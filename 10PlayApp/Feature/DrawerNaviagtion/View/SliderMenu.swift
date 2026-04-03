////
////  SliderMenu.swift
////  10PlayApp
////
////  Created by savan soni on 02/04/26.
////


import UIKit

class SliderMenu: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userSupportLabel: UILabel!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var logoutView: UIButton!
    @IBOutlet weak var rgpdView: UIButton!
    @IBOutlet weak var syncView: UIView!
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var bottomVersonLabel: UILabel!
    
    
    var onMenuTap: ((MenuAction) -> Void)?
    
    private let drawerWidth: CGFloat = 250
    private var isPresented = false
    private var dimLayer: CALayer?
    
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
        guard let views = Bundle.main.loadNibNamed("SliderMenu", owner: self, options: nil),
              let _ = views.first else { return }

        self.backgroundColor = .clear
        contentView.backgroundColor = .black
        contentView.clipsToBounds = false
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.autoresizingMask = [.flexibleHeight]
        contentView.frame = CGRect(x: -drawerWidth, y: 0, width: drawerWidth, height: UIScreen.main.bounds.height)

        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(hide))
        outsideTap.cancelsTouchesInView = false
        outsideTap.delegate = self
        self.addGestureRecognizer(outsideTap)
        
        homeButton.setStyle(weight: .extraBold, size: 18)
        accountButton.setStyle(weight: .extraBold, size: 18)
        contactButton.setStyle(weight: .extraBold, size: 18)
        
        userSupportLabel.font = AppFont.get(.regular, size: 13.5)
        
        logoutView.setStyle(weight: .extraBold, size: 18)
        
        rgpdView.setStyle(weight: .extraBold, size: 14,horizontalPadding: 30,verticalPadding: 10,isCapsule: true)
        syncLabel.font = AppFont.get(.regular, size: 12)
        bottomVersonLabel.font = AppFont.get(.medium, size: 12
        )
    }
    
    
    func show(in parentView: UIView) {
        guard !isPresented else { return }
        isPresented = true

        self.frame = parentView.bounds
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
            self.applyDimOverlay()
            self.contentView.frame.origin.x = 0
        })
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.contentView.frame.origin.x = -self.drawerWidth
            self.backgroundColor = .clear
        }) { _ in
            self.isPresented = false
            self.dimLayer?.removeFromSuperlayer()
            self.dimLayer = nil
            self.removeFromSuperview()
        }
    }

    private func applyDimOverlay() {
        dimLayer?.removeFromSuperlayer()

        let overlay = CAGradientLayer()
        overlay.frame = self.bounds
        overlay.startPoint = CGPoint(x: 0, y: 0.5)
        overlay.endPoint   = CGPoint(x: 1, y: 0.5)

        let drawerRatio = drawerWidth / self.bounds.width
        overlay.colors = [
            UIColor.black.withAlphaComponent(0.85).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,   // just past drawer edge
            UIColor.black.withAlphaComponent(0.0).cgColor    // far right = transparent
        ]
        overlay.locations = [0, NSNumber(value: drawerRatio + 0.01), 1.0]

        self.layer.insertSublayer(overlay, at: 0)
        self.dimLayer = overlay
    }
    
    // MARK: - Gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        return point.x > drawerWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let currentX = contentView.frame.origin.x
        contentView.frame = CGRect(x: currentX, y: 0, width: drawerWidth, height: self.bounds.height)
        dimLayer?.frame = self.bounds
        
        
        syncView.layer.sublayers?.removeAll(where: { $0.name == "borderLayer" })
            
            let top = CALayer()
            top.name = "borderLayer"
            top.frame = CGRect(x: 0, y: 0, width: syncView.bounds.width, height: 3)
        top.backgroundColor = UIColor.white.cgColor
        syncView.layer.addSublayer(top)

            let bottom = CALayer()
            bottom.name = "borderLayer"
            bottom.frame = CGRect(x: 0, y: syncView.bounds.height - 1, width: syncView.bounds.width, height: 3)
        bottom.backgroundColor = UIColor.white.cgColor
        syncView.layer.addSublayer(bottom)
    }
    
    
    func addTopBottomBorder(to view: UIView, color: UIColor = .white, thickness: CGFloat = 1.0) {
        let top = CALayer()
        top.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: thickness)
        top.backgroundColor = color.cgColor
        view.layer.addSublayer(top)

        let bottom = CALayer()
        bottom.frame = CGRect(x: 0, y: view.bounds.height - thickness, width: view.bounds.width, height: thickness)
        bottom.backgroundColor = color.cgColor
        view.layer.addSublayer(bottom)
    }
    
    
    @IBAction func hideDrawer(_ sender: Any) {
        hide()
    }
    @IBAction func onPressHome(_ sender: Any) {
        onMenuTap?(.home)
        hide()
    }

    @IBAction func onPressAccount(_ sender: Any) {
        onMenuTap?(.account)
        hide()
    }

    @IBAction func onPressContact(_ sender: Any) {
        onMenuTap?(.contact)
        hide()
    }

    @IBAction func onPressLogout(_ sender: Any) {
        onMenuTap?(.logout)
        hide()
    }
}
