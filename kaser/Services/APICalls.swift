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

    func addSellerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, storeName: String, location: [String?:String?] , userType: String, image: String, pass:String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: location, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
        ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "Store Name": storeName, "Location ": encodingLocation, "profileImage" : image, "Password" : pass] as [String : Any]) {
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
} catch {
    print("Error converting dictionary to string: \(error)")
}

}
    
    func addBuyerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, userType: String, image: String,location: [String?:String?] , pass:String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: location, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
                ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "profileImage" : image, "location" : encodingLocation, "Password" : pass] as [String : Any]) {
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
        } catch {
            print("Error converting dictionary to string: \(error)")
        }

    }
    
    func addStoreInfo(storeName: String, phone: String, address: String, delivery: String, description: String, image: String, completion: ((Bool) -> Void)?){
        ref.child("Stores").child(storeName).setValue(["storeName": storeName, "phone": phone, "address": address, "delivery": delivery, "description" : description, "storeImage" : image, "storeOwner" : newEmail]) {
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
    
    func addProductInfo(productName: String, storeName: String, brand: String, car: String, condition: String, description: String, image: String, completion: ((Bool) -> Void)?){
        ref.child("Products").child(storeName).child(productName).setValue(["productName": productName, "brand": brand, "car": car, "condition": condition, "description" : description, "productImage" : image, "productOwner" : newEmail]) {
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
                completion?(false)
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
    
    func getStores(completion: ((Bool) -> Void)?) {
        ref.child("Stores").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion?(false)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                if let value = snapshot.value as? [String: Any] {
                    storesArray.removeAll()
                    for (_, storeData) in value {
                        if let storeData = storeData as? [String: Any] {
                            let jsonData = try JSONSerialization.data(withJSONObject: storeData)
                            let store = try decoder.decode(Store.self, from: jsonData)
                            storesArray.append(store)
                        }
                    }
                    
                    // Access the storesArray here
                    print(storesArray)
                    
                    completion?(true)
                } else {
                    completion?(false)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion?(false)
            }
        })
    }
    
    func getProducts(store: String, completion: @escaping (Bool) -> Void) {
//        var productsArray: [Product] = []
        ref.child("Products").child(store).getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }

            let decoder = JSONDecoder()
            do {
                if let productData = snapshot.value as? [String: [String: Any]] {
                    productsArray.removeAll()
                    for (_, productDict) in productData {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: productDict) {
                            let product = try decoder.decode(Product.self, from: jsonData)
                            productsArray.append(product)
                        }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(false)
            }
        })
    }


    
    
}
