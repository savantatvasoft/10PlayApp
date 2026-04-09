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
    @IBOutlet weak var missionStatus: DropDownContainer!
    @IBOutlet weak var regionDropDownContainer: DropDownContainer!
    @IBOutlet weak var apartmentDropDownContainer: DropDownContainer!
    @IBOutlet weak var cantionDropDownContainer: DropDownContainer!
    @IBOutlet weak var govtDropDownContainer: DropDownContainer!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabelBackAction = true
        header.centerTitle.text = "filter_list_header".localized
        header.centerIcon.isHidden = true
        header.centerTitle.isHidden = false
        if let backImage = UIImage(named: "Ico_back_nav_menu") {
            header.leftImage.setImage(backImage, for: .normal)
            header.rightImage.setImage(UIImage(named: "ic_10_play_white"), for: .normal)
        }
        setUp()
        attachHeader(header)
        setUPDropDownContainer()
        setupBottomViewStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shadowRect = bottomView.bounds
        bottomView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
    @IBAction func onFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "naviagteToListOfMissions", sender: self)
    }
    
    @IBAction func onReset(_ sender: Any) {
    }
}


extension FilterVC {
    
    func setUPDropDownContainer() {
        projectDropDownContainer.configure(
            label: "project_field".localized,
            title: "project_default".localized,
            items: projectItems
        )

        missionStatus.configure(
            label: "mission_field".localized,
            title: "mission_default".localized,
            items: missionStatusItems
        )

        regionDropDownContainer.configure(
            label: "region_field".localized,
            title: "region_default".localized,
            items: regionItems
        )

        apartmentDropDownContainer.configure(
            label: "apartment_field".localized,
            title: "apartment_default".localized,
            items: apartmentItems
        )

        cantionDropDownContainer.configure(
            label: "canton_field".localized,
            title: "canton_default".localized,
            items: cantonItems
        )

        govtDropDownContainer.configure(
            label: "government_field".localized,
            title: "government_default".localized,
            items: governmentItems
        )
    }
    
    func setUp() {
        filterBtn.setStyle(weight: .bold, size: 14,verticalPadding: 8)
        resetBtn.setStyle(weight: .extraBold, size: 14,verticalPadding: 8)
    }
    
    private func setupBottomViewStyle() {
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10.0
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -5)
        bottomView.layer.masksToBounds = false
        bottomView.clipsToBounds = false
    }
}
