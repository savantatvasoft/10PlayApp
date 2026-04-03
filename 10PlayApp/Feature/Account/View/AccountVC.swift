//
//  AccountVC.swift
//  10PlayApp
//
//  Created by savan soni on 03/04/26.
//

import UIKit

class AccountVC: BaseViewController {

    @IBOutlet weak var header: Header!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        header.configure(headerTitle: "account_title".localized,rightIcon: UIImage(named: "ic_10_play_white"))
        attachHeader(header)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
