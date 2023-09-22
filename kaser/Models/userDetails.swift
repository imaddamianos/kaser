//
//  userDetails.swift
//  kaser
//
//  Created by imad on 9/11/22.
//

import Foundation

var userDetails: usersStruct?
//var productsDetails: productsStruct?
var storesName: [String]?

struct usersStruct {
    var mobile: String?
    var email: String?
    var name: String?
    var pass: String?
    var dob: String?
    var location: String?
    var LocationName: String?
    var image: String?
    var UserName: String?
    var userType: String?
}

struct productsStruct: Codable {
    
    var location: String?
    var phone: String?
    var views: String?
    var carModel: String?
    var image: String?
    var isFav: String?
}

