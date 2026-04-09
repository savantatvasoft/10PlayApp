//
//  ContactVC.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import UIKit

class ContactVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: Header!
    
    var sections: [ContactSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.centerTitle.text = "conatct_header".localized
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        header.rightImage.setImage(UIImage(named: "ic_10_play_white"), for: .normal)
        
        attachHeader(header)
        setupData()
        setupTableView()
    }
}


extension ContactVC {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    private func setupData() {
        let companySection = ContactSection(
            sectionTitle: "contact_section_company".localized,
            items: [
                ContactItem(title: "contact_email_company".localized, iconName: "envelope"),
                ContactItem(title: "contact_call_company".localized, iconName: "iphone.and.arrow.forward.outward")
            ]
        )
        
        let managerSection = ContactSection(
            sectionTitle: "contact_section_manager".localized,
            items: [
                ContactItem(title: "contact_email_manager".localized, iconName: "envelope"),
                ContactItem(title: "contact_call_manager".localized, iconName: "iphone.and.arrow.forward.outward")
            ]
        )
        
        sections = [companySection, managerSection]
    }
    
    private func openEmail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Mail services are not available on this device.")
            }
        }
    }

    private func makeCall(to phoneNumber: String) {
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(cleanNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Phone services are not available on this device.")
            }
        }
    }
}


extension ContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.text = sections[section].sectionTitle
        label.font = AppFont.get(.extraBold, size: 14)
        label.textColor = UIColor(named: "RedColor") ?? .red
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        
        if item.iconName == "envelope" {
            openEmail(to: "support@dummy10play.com")
        } else if item.iconName == "iphone.and.arrow.forward.outward" {
            makeCall(to: "+1234567890")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.font = AppFont.get(.regular, size: 14)
        cell.textLabel?.textColor = .darkGray
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        cell.imageView?.image = UIImage(systemName: item.iconName, withConfiguration: iconConfig)
        cell.imageView?.tintColor = .black
        cell.selectionStyle = .none
    
        let separatorTag = 1001
        cell.contentView.viewWithTag(separatorTag)?.removeFromSuperview()
        
        let isLastCell = indexPath.row == (sections[indexPath.section].items.count - 1)
        
        if !isLastCell {
            let separator = UIView()
            separator.tag = separatorTag
            separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(separator)
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1.0)
            ])
        }
        
        return cell
    }
}
