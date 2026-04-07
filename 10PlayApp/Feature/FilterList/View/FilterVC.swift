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

    private var regionItems: [DropDownItem] {
        [
            DropDownItem(id: "0", title: "all_regions".localized),
            DropDownItem(id: "1", title: "auvergne_rhone_alpes".localized),
            DropDownItem(id: "2", title: "bretagne".localized)
        ]
    }
    
    private var  regionsData:[DropDownItem] {
        [
            DropDownItem(id: "0", title: "Toutes les régions"),
            DropDownItem(id: "1", title: "Auvergne-Rhône-Alpes"),
            DropDownItem(id: "2", title: "Bourgogne-Franche-Comté"),
            DropDownItem(id: "3", title: "Bretagne"),
            DropDownItem(id: "4", title: "Centre-Val de Loire"),
            DropDownItem(id: "5", title: "Corse"),
            DropDownItem(id: "6", title: "Grand Est"),
            DropDownItem(id: "7", title: "Haut de France"),
            DropDownItem(id: "8", title: "Île-de-France"),
            DropDownItem(id: "9", title: "Normandie"),
            DropDownItem(id: "10", title: "Nouvelle Aquitaine"),
            DropDownItem(id: "11", title: "Occitanie"),
            DropDownItem(id: "12", title: "Pays de la Loire")
        ]
    }

    private var projectItems: [DropDownItem] { regionItems }
    private var missionStatusItems: [DropDownItem] { regionItems }
    private var apartmentItems: [DropDownItem] { regionsData }
    private var cantonItems: [DropDownItem] { regionItems }
    private var governmentItems: [DropDownItem] { regionItems }

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
}
