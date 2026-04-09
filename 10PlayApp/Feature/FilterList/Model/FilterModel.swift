//
//  FilterModel.swift
//  10PlayApp
//
//  Created by savan soni on 07/04/26.
//

import Foundation
import UIKit

struct DropDownItem {
    let id: String
    let title: String
}

struct MissionFilter {
    let iconName: String
    let title: String
    let count: Int
    let iconColor: UIColor
}


let filterItems: [MissionFilter] = [
    MissionFilter(iconName: "Pin_to_displayed",
                  title: "filter_remaining".localized,
                  count: 0, iconColor: .systemOrange),
                  
    MissionFilter(iconName: "Pin_realized",
                  title: "filter_completed".localized,
                  count: 0, iconColor: .systemGreen),
                  
    MissionFilter(iconName: "Pin_missing",
                  title: "filter_impossible".localized,
                  count: 1, iconColor: .systemRed),
                  
    MissionFilter(iconName: "Pin_new_panel",
                  title: "filter_new".localized,
                  count: 7, iconColor: .systemBlue),
                  
    MissionFilter(iconName: "Pin_all_pannel",
                  title: "filter_all".localized,
                  count: 8, iconColor: .systemGray)
]


var regionItems: [DropDownItem] {
    [
        DropDownItem(id: "0", title: "all_regions".localized),
        DropDownItem(id: "1", title: "auvergne_rhone_alpes".localized),
        DropDownItem(id: "2", title: "bretagne".localized)
    ]
}

var  regionsData:[DropDownItem] {
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


var projectItems: [DropDownItem] { regionItems }
var missionStatusItems: [DropDownItem] { regionItems }
var apartmentItems: [DropDownItem] { regionsData }
var cantonItems: [DropDownItem] { regionItems }
var governmentItems: [DropDownItem] { regionItems }
