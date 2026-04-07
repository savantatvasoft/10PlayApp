//
//  FilterVC.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import UIKit

class FilterVC: BaseViewController {

    @IBOutlet weak var header: Header!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var projectDropDownContainer: DropDownContainer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabelBackAction = true
        header.centerTitle.text = "filter_list_header".localized
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        if let backImage = UIImage(named: "Ico_back_nav_menu") {
            header.leftImage.setImage(backImage, for: .normal)
        }
        attachHeader(header)
        setUPDropDownContainer()
    }
    
}


extension FilterVC {
    
    func setUPDropDownContainer() {
        
        projectDropDownContainer.topLabel.text = "project_field".localized
        projectDropDownContainer.titleLabel.text = "LRYE"
    }
    
}
