//
//  FilterMapVC.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//


import UIKit

class FilterMapVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
        view.backgroundColor = .white
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 55
        tableView.estimatedRowHeight = 55
    }
}

// MARK: - TableView Methods
extension FilterMapVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MissionCell", for: indexPath) as? MissionCell else {
            return UITableViewCell()
        }
        
        let item = filterItems[indexPath.row]
        let isLastRow = indexPath.row == filterItems.count - 1
        cell.configure(with: item, isLastRow: isLastRow)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle filter selection logic here
        print("Selected: \(filterItems[indexPath.row].title)")
    }
    
    
    private func setupHeader() {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "MissionCell") as? MissionCell else {
            return
        }
        
        headerCell.titile.text = "LRYE"
        headerCell.titile.textColor = UIColor(named: "RedColor")
        headerCell.titile.font = AppFont.get(.bold, size: 18)
        headerCell.leftIcon.image = UIImage(named: "Ico_filter_header")
        
        headerCell.countView.isHidden = true
        headerCell.closeBtnView.isHidden = false
        
        headerCell.onClosePressed = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let headerHeight: CGFloat = 60
        headerCell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
        
        tableView.tableHeaderView = headerCell
    }
}
