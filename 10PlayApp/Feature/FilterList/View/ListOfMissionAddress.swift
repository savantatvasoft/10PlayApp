//
//  ListOfMissionAddress.swift
//  10PlayApp
//
//  Created by savan soni on 08/04/26.
//


import UIKit

class ListOfMissionAddress: BaseViewController {

    @IBOutlet weak var header: Header!
    @IBOutlet weak var tableView: UITableView!
    
    // Data model matching your screenshot
    private var missionAddresses: [(ville: String, adresse: String)] = [
        ("75004, Paris", "Hôtel de Ville 75004"),
        ("380061", "3GFJ+6Q7, Vishwas City 1, Chanakyapuri, Ahmedabad, Gujarat 380061, India 380061 Ahmedabad, India"),
        ("380061", "3GFJ+6Q7, Vishwas City 1, Chanakyapuri, Ahmedabad, Gujarat 380061, India 380061 Ahmedabad, India"),
        ("380054", "Bodakdev 380054"),
        ("380054", "Bodakdev 380054"),
        ("395008", "Test 70123")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        enabelBackAction = true
        header.centerTitle.text = "filter_list_header".localized
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        
        if let backImage = UIImage(named: "Ico_back_nav_menu") {
            header.leftImage.setImage(backImage, for: .normal)
        }
        header.rightImage.setImage(UIImage(named: "ic_10_play_white"), for: .normal)
        
        attachHeader(header)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}

// MARK: - TableView Methods

extension ListOfMissionAddress: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionAddresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MissionAddressCell", for: indexPath) as? MissionAddressCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let data = missionAddresses[indexPath.row]
        cell.configure(ville: data.ville, adresse: data.adresse)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let popup = AddressPopUp()
        
        let data = missionAddresses[indexPath.row]
        
        popup.headerLabel.text = "LRYE"
        popup.statusValue.text = "Nouvelle mission validée"
        popup.postalValue.text = data.ville
        popup.addressValue.text = data.adresse
        popup.comentaryValue.text = "#doublon"
        
        popup.show(in: self.view)
    }
}
