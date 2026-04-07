//
//  DropDownContainer.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import UIKit


class DropDownContainer: UIView {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    
    // MARK: - State
    private var selectedItem: DropDownItem?
    private var dropdownItems: [DropDownItem] = []

    // MARK: - Action
    @IBAction func onPress(_ sender: Any) {
        guard let parentVC = parentViewController else { return }

        // Remove any existing dropdown + overlay
        dismissAll()

        // 1. Dim overlay
        let dismissOverlay = UIView(frame: parentVC.view.bounds)
        dismissOverlay.backgroundColor = .black.withAlphaComponent(0.3)
        dismissOverlay.tag = 9999
        parentVC.view.addSubview(dismissOverlay)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAll))
        dismissOverlay.addGestureRecognizer(tap)

        // 2. Get button frame in parentVC coordinate space
        let buttonFrame = self.convert(self.bounds, to: parentVC.view)

        // 3. Calculate dynamic height based on item count, capped at 400
        let dropdownHeight = DropDownListView.calculatedHeight(for: dropdownItems.count)

        // 4. Create and position dropdown
        let dropdown = DropDownListView()
        dropdown.frame = CGRect(
            x: buttonFrame.minX,
            y: buttonFrame.maxY + 4,
            width: buttonFrame.width,
            height: dropdownHeight + 40
        )
        parentVC.view.addSubview(dropdown)

        dropdown.configure(
            items: dropdownItems,
            selected: selectedItem,
            header: "Toutes les régions"
        ) { [weak self] item in
            guard let self = self else { return }
            self.selectedItem = item
            self.updateButtonUI(title: item.title)
            self.dismissAll()
        }
    }

    @objc func dismissAll() {
        guard let parentVC = parentViewController else { return }
        parentVC.view.subviews.filter { $0 is DropDownListView }.forEach { $0.removeFromSuperview() }
        parentVC.view.subviews.filter { $0.tag == 9999 }.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Init
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
    
    private func setUp() {
        topLabel.font = AppFont.get(.extraBold, size: 13)
        updateButtonUI(title: titleBtn.title(for: .normal) ?? "")
    }

    // MARK: - Public Configure
    func configure(label: String, title: String, items: [DropDownItem]) {
        topLabel.text = label
        dropdownItems = items
        // Set initial selected item matching title
        selectedItem = items.first { $0.title == title }
        updateButtonUI(title: title)
    }

    // MARK: - Private
    private func updateButtonUI(title: String) {
        var config = titleBtn.configuration ?? .plain()
        
        var container = AttributeContainer()
        container.font = AppFont.get(.regular, size: 14)
        container.foregroundColor = UIColor.darkGray
        
        config.attributedTitle = AttributedString(title, attributes: container)
        config.imageColorTransformer = UIConfigurationColorTransformer { _ in .lightGray }
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 4)
        config.imagePadding = 5
        
        titleBtn.configuration = config
    }
}

