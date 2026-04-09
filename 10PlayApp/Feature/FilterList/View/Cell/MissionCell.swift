//
//  MissionCell.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//

import UIKit

class MissionCell: UITableViewCell {
    
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var hstack: UIStackView!
    @IBOutlet weak var titile: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var closeBtnView: UIButton!
    
    var onClosePressed: (() -> Void)?
    private let bottomBorder = CALayer()
    
    @IBAction func onClose(_ sender: Any) {
        onClosePressed?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
        closeBtnView.isUserInteractionEnabled = true
        bottomBorder.backgroundColor = UIColor.systemGray4.cgColor
        contentView.layer.addSublayer(bottomBorder)
        contentView.bringSubviewToFront(closeBtnView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorderFrame()
        countView.layer.cornerRadius = countView.frame.height / 2
    }
    
    func updateBorderFrame() {
        let thickness: CGFloat = 0.5
        bottomBorder.frame = CGRect(x: 0,
                                    y: contentView.frame.height - thickness,
                                    width: contentView.frame.width,
                                    height: thickness)
    }
    
    private func setupUI() {
        titile.font = AppFont.get(.medium, size: 13.5)
        titile.textColor = .darkGray
        countLabel.font = AppFont.get(.bold, size: 8)
        countLabel.textColor = .white
        
        countView.backgroundColor = .systemGray
        countView.clipsToBounds = true
        closeBtnView.isHidden = true
        selectionStyle = .none
    }
    
    func configure(with item: MissionFilter, isLastRow: Bool) {
        countView.isHidden = isLastRow ? true : false
        titile.text = item.title
        countLabel.text = "\(item.count)"
        leftIcon.image = UIImage(named: item.iconName)
        leftIcon.tintColor = item.iconColor
    }
}
