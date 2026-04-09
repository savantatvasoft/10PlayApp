//
//  MissionAddressCell.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//

import UIKit

class MissionAddressCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var villeTitleLabel: UILabel!
    @IBOutlet weak var villeValueLabel: UILabel!
    @IBOutlet weak var adresseTitleLabel: UILabel!
    @IBOutlet weak var adresseValueLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
//        applyInsets()   // 👈 spacing handled here
    }

    // MARK: - Setup UI
    private func setupUI() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .white
        
        // Fonts
        let titleFont = AppFont.get(.bold, size: 12)
        let valueFont = AppFont.get(.regular, size: 12)
        
        villeTitleLabel.font = titleFont
        adresseTitleLabel.font = titleFont
        
        villeValueLabel.font = valueFont
        adresseValueLabel.font = valueFont
        
        villeTitleLabel.text = "address_ville_title".localized
        adresseTitleLabel.text = "address_adresse_title".localized
    }
    // MARK: - Configure
    func configure(ville: String, adresse: String) {
        villeValueLabel.text = ville
        adresseValueLabel.text = adresse
    }
}
