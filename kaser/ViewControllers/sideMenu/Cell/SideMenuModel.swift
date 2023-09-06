//
//  MenuModel.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/20/21.
//

import UIKit

var sideMenu: [SideMenuModel] = []

struct SideMenuModel {
    var icon: UIImage
    var title: String
}

var carsBrands: [CarsBandsModel] = []

struct CarsBandsModel: Decodable {
    var title: String
    var icon: String
}





