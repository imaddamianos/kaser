//
//  StoreDetails.swift
//  kaser
//
//  Created by iMad on 14/06/2023.
//

import Foundation

var storesArray: [Store] = []
var productsArray: [Product] = []

struct Store: Codable {
    let storeName: String
    let phone: String
    let address: String
    let delivery: String
    let description: String
    let storeImage: String
    let storeOwner: String
}

struct Product: Codable {
    let productName: String
    let brand: String
    let car: String
    let condition: String
    let description: String
    let productImage: String
    let productOwner: String
}

