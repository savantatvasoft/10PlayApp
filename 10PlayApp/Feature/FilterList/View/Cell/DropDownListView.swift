//
//  DropDownListView.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//
import UIKit

class DropDownListView: UIView {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var triangleView: TriangleView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Data
    private var items: [DropDownItem] = []
    private var selectedItem: DropDownItem?
    private var headerTitle: String?
    
    // MARK: - Callback
    var onSelect: ((DropDownItem) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle.main
        let nibViews = bundle.loadNibNamed("DropDownListView", owner: self, options: nil)
        
        guard let contentView = nibViews?.first as? UIView else {
            assertionFailure("Failed to load DropDownListView from nib")
            return
        }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupUI(in: contentView)
    }

    private func setupUI(in contentView: UIView) {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = .zero
        tableView.rowHeight = 40
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor)
        ])

        triangleView.clipsToBounds = false
        container.backgroundColor = .clear
        container.clipsToBounds = false

        // tableViewContainer handles corner radius + shadow
        tableViewContainer.clipsToBounds = true
        tableViewContainer.layer.cornerRadius = 1
        tableViewContainer.backgroundColor = .white

        // Shadow on container since tableViewContainer clips
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupHeader() {
        guard let title = headerTitle else {
            tableView.tableHeaderView = nil
            return
        }
        
        let topPadding: CGFloat = 10
        let labelHeight: CGFloat = 40
        let totalHeaderHeight = topPadding + labelHeight
    
        let headerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.frame.width,
            height: totalHeaderHeight
        ))
        headerView.backgroundColor = .white
        let label = UILabel(frame: CGRect(
            x: 16,
            y: topPadding,
            width: tableView.frame.width - 32,
            height: labelHeight
        ))
        
        label.text = title
        label.font = AppFont.get(.extraBold, size: 14)
        label.textColor = .black
        
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
    }

    func configure(items: [DropDownItem],
                   selected: DropDownItem? = nil,
                   header: String? = nil,
                   onSelect: @escaping (DropDownItem) -> Void) {
        
        self.items = items
        self.selectedItem = selected
        self.headerTitle = header
        self.onSelect = onSelect
        
        setupHeader()
        tableView.reloadData()
    }

    // MARK: - Dynamic Height
    static let cellHeight: CGFloat = 40
    static let triangleHeight: CGFloat = 30
    static let maxHeight: CGFloat = 400

    static func calculatedHeight(for itemCount: Int) -> CGFloat {
        let tableHeight = min(CGFloat(itemCount) * cellHeight, maxHeight - triangleHeight)
        return tableHeight + triangleHeight
    }
}

// MARK: - UITableViewDelegate & DataSource
extension DropDownListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]

        cell.textLabel?.text = item.title
        cell.textLabel?.font = AppFont.get(.regular, size: 14)
        cell.textLabel?.textColor = .darkGray
        cell.selectionStyle = .none
        cell.backgroundColor = .white

    
        if item.id == selectedItem?.id {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = UIColor(named: "RedColor") ?? .red
            checkmark.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            checkmark.contentMode = .scaleAspectFit
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedItem = item
        tableView.reloadData()

        onSelect?(item)

        // Small delay so user sees checkmark before dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
