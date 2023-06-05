//
//  APICalls.swift
//  kaser
//
//  Created by imps on 11/4/21.
//

import Foundation
import Firebase

class APICalls: NSObject {
    static let shared: APICalls = APICalls()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func addSellerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, storeName: String, location: [String:Int] , userType: String, image: String, pass:String, completion: ((Bool) -> Void)?){
        ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "Store Name": storeName, "Location ":[ "lat": 34, "long" :65], "profileImage" : image, "Password" : pass]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            completion?(false)
          } else {
            print("Data saved successfully!")
            completion?(true)
          }
        }
    }
    
    func addBuyerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, userType: String, image: String, pass:String, completion: ((Bool) -> Void)?){
        ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "profileImage" : image, "Password" : pass]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            completion?(false)
          } else {
            print("Data saved successfully!")
            completion?(true)
          }
        }
    }
    
    func getUserInfo(name: String, completion: ((Bool) -> Void)?){
        ref.child("Seller").child(newID!).getData(completion:  { error, snapshot in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
              }
            let value = snapshot.value as? NSDictionary
            let mobile = value?["Mobile"] as? String ?? "No number"
            let email = value?["Email"] as? String ?? "No Email"
            let name = value?["Name"] as? String ?? "No Name"
            let pass = value?["Password"] as? String ?? "No Name"
            let dob = value?["DOB"] as? String ?? "No DOB"
            let image = value?["profileImage"] as? String ?? "No image"
            let UserName = value?["UserName"] as? String ?? "No UserName"
            let userType = value?["userType"] as? String ?? "No userType"
            
            if UserName == "No UserName"{
                
                ref.child("Buyer").child(newID!).getData(completion:  { error, snapshot in
                    let value = snapshot.value as? NSDictionary
                    let mobile = value?["Mobile"] as? String ?? "No number"
                    let email = value?["Email"] as? String ?? "No Email"
                    let name = value?["Name"] as? String ?? "No Name"
                    let pass = value?["Password"] as? String ?? "No Name"
                    let dob = value?["DOB"] as? String ?? "No DOB"
                    let image = value?["profileImage"] as? String ?? "No image"
                    let UserName = value?["UserName"] as? String ?? "No UserName"
                    let userType = value?["userType"] as? String ?? "No userType"
                    
                    userDetails = usersStruct(mobile: mobile, email: email, name: name, pass: pass, dob: dob, image: image, UserName: UserName, userType: userType)
                    completion?(true)
            })
            }else{
                userDetails = usersStruct(mobile: mobile, email: email, name: name, pass: pass, dob: dob, image: image, UserName: UserName, userType: userType)
                completion?(true)
            }
    })
    }
//
//    func getProducts(name: String, completion: ((Bool) -> Void)?){
//        ref.child("Stores").child(name).getData(completion:  { error, snapshot in
//
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//              }
//            let value = snapshot.value as? NSDictionary
//            let location = value?["Location"] as? String ?? "No Location"
//            let phoneNb = value?["Phone number"] as? String ?? "No Phone number"
//            let views = value?["Views"] as? String ?? "No views"
//            let carModel = value?["car model"] as? String ?? "No car Model"
//            let image = value?["image"] as? String ?? "No image"
//            let isFav = value?["isFav"] as? String ?? "No fav result"
////            storesName = stores
//            productsDetails = productsStruct(location: location, phone: phoneNb, views: views, carModel: carModel, image: image, isFav: isFav)
//                completion?(true)
//    })
//    }
    
    func getStores(completion: ((Bool) -> Void)?){
        ref.child("Stores").getData(completion:  { error, snapshot in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
              }
            let value = snapshot.value as? NSDictionary
            let stores = value?.allKeys as? [String]
            storesName = stores
                completion?(true)
    })
    }
    
    
}
