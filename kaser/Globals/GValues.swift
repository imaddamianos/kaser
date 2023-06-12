//
//  GValues.swift
//  kaser
//
//  Created by imps on 10/16/21.
//


import Foundation
import Firebase
import SCLAlertView

var ref = Database.database().reference()
var firebaseRef = Auth.auth()
let storageRef = Storage.storage().reference()
let imageRef = storageRef.child("image/Profile/file-\(String(describing: newEmail!)).png")
let imageStoreRef = storageRef.child("image/Stores/file-\(String(describing: newEmail!)).png")
//let storageRef = storage.reference()
var alertView = SCLAlertView()
var newEmail: String?
var newPass: String?
var newID: String?
