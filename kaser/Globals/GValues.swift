//
//  GValues.swift
//  kaser
//
//  Created by imps on 10/16/21.
//


import Foundation
import Firebase
import SCLAlertView

var alertView = SCLAlertView()
var newEmail: String?
var newPass: String?
var newID: String?
var storeNamePath: String?
var productNamePath: String?
var ref = Database.database().reference()
var firebaseRef = Auth.auth()
let storageRef = Storage.storage().reference()
let imageRef = storageRef.child("image/Profile/file-\(String(describing: newEmail!)).png")
let imageStoreRef = storageRef.child("image/Stores/\(storeNamePath!)/file-\(String(describing: newEmail!)).png")
let imageProductRef = storageRef.child("image/Products/\(storeNamePath!)/\(String(describing: productNamePath!)).png")
var imageCache: NSCache<NSString, UIImage> = NSCache()
//let storageRef = storage.reference()
