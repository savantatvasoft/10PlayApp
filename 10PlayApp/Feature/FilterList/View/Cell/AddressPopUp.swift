//
//  AddressPopUp.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//

import UIKit

class AddressPopUp: UIView {

    // MARK: - Outlets
    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var postalValue: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var comentaryLabel: UILabel!
    @IBOutlet weak var comentaryValue: UILabel!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }

    // MARK: - Load XIB
    private func loadXib() {
        let nib = UINib(nibName: "AddressPopUp", bundle: nil)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)   // 👈 directly add root view
        
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true
        
        addressValue.numberOfLines = 0
    }

    // MARK: - Actions
    @IBAction func onPressClose(_ sender: Any) {
        dismiss()
    }

    // MARK: - Show
    func show(in parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)

        cardView.transform = CGAffineTransform(translationX: 0, y: 300)

        UIView.animate(withDuration: 0.3) {
            self.cardView.transform = .identity
        }
    }

    // MARK: - Dismiss
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.cardView.transform = CGAffineTransform(translationX: 0, y: 300)
            self.backgroundColor = .clear
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
