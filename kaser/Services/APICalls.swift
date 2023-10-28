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

    func addSellerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, storeName: String, location: [String?:String?] ,LocationName: String, userType: String, image: String, pass:String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: location, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
                ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "Store Name": storeName, "Location": encodingLocation, "LocationName" : LocationName, "profileImage" : image, "Password" : pass] as [String : Any]) {
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
    
    func modifyInfo(userName: String, userType:String, email: String, mobile: String, DateOfBirth: String, location: [String?:String?] , image: String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: location, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
                
        ref.child(userType).child(newID!).updateChildValues(["UserName": userName, "Email": email, "Mobile": mobile, "DOB": DateOfBirth, "Location": encodingLocation, "profileImage" : image] as [String : Any]) {
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
    
    func modifyProductInfo(storeName: String,productName: String,productDescription: String, brand:String, price: String,condition: String, completion: ((Bool) -> Void)?){
        do {
            ref.child("Products").child("elegant motors").child(productName).updateChildValues(["productName": productName, "Price": price, "brand": brand,"condition": condition, "description": productDescription]) {
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
        
    }
    
    func modifyStoreInfo(storeName: String, locationName:String, delivery: String, description: String, phone: String, completion: ((Bool) -> Void)?){
        do {
            ref.child("Stores").child(storeName).updateChildValues(["storeName": storeName, "locationName": locationName, "delivery": delivery, "description": description, "phone": phone]) {
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
    }
    
    func addBuyerInfo(userName: String, firstName: String, lastName: String, email: String, mobile: String, DateOfBirth: String, userType: String, image: String,location: [String?:String?] ,LocationName: String, pass:String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: location, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
                ref.child(userType).child(newID!).setValue(["UserName": userName, "Name": firstName + " " + lastName, "Email": email, "Mobile": mobile, "userType": userType, "DOB": DateOfBirth, "profileImage" : image, "Location" : encodingLocation, "LocationName" : LocationName, "Password" : pass] as [String : Any]) {
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
    
    func addStoreInfo(storeName: String, phone: String, address: [String?:String?],LocationName: String, delivery: String, description: String, image: String, completion: ((Bool) -> Void)?){
        do {
            let jsonDataLocation = try JSONSerialization.data(withJSONObject: address, options: [])
            if let encodingLocation = String(data: jsonDataLocation, encoding: .utf8) {
                ref.child("Stores").child(storeName).setValue(["storeName": storeName, "phone": phone, "address": encodingLocation, "LocationName": LocationName, "delivery": delivery, "description" : description, "storeImage" : image, "storeOwner" : newEmail as Any] as [String : Any]) {
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
    
    func addProductInfo(productName: String, storeName: String, brand: String, price: String, condition: String, description: String, image: String, completion: ((Bool) -> Void)?){
        ref.child("Products").child(storeName).child(productName).setValue(["productName": productName, "brand": brand, "Price": price, "condition": condition, "description" : description, "productImage" : image, "productOwner" : newEmail]) {
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
            let location = value?["Location"] as? String ?? "No location"
            let locationName = value?["LocationName"] as? String ?? "No Location Name"
            
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
                    let location = value?["Location"] as? String ?? "No location"
                    let locationName = value?["LocationName"] as? String ?? "No Location Name"
                    
                    userDetails = usersStruct(mobile: mobile, email: email, name: name, pass: pass, dob: dob, location: location, LocationName: locationName, image: image, UserName: UserName, userType: userType)
                    completion?(true)
            })
            }else{
                userDetails = usersStruct(mobile: mobile, email: email, name: name, pass: pass, dob: dob, location: location, LocationName: locationName, image: image, UserName: UserName, userType: userType)
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
//        productsArray.removeAll()
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
//                            if product.productOwner == email {
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

    func getAllProducts(completion: @escaping ([Product]?) -> Void) {
        // Define a reference to the "Products" node
        let productsRef = ref.child("Products")
        productsArray.removeAll()
        // Observe changes at this reference
        productsRef.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                // Handle the case where no data exists for products
                completion(nil)
                return
            }
            // Initialize a JSONDecoder
            let decoder = JSONDecoder()
            
            // Enumerate through the snapshot's children (store nodes)
            for storeSnapshot in snapshot.children {
                guard let storeData = (storeSnapshot as? DataSnapshot)?.value as? [String: [String: Any]] else {
                    continue // Skip this store if data is invalid
                }
                
                // Iterate through the products of this store
                for (_, productDict) in storeData {
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: productDict) else {
                        continue // Skip this product if data is invalid
                    }
                    
                    do {
                        // Decode the product data into a Product object
                        let product = try decoder.decode(Product.self, from: jsonData)
                        productsArray.append(product)
                    } catch {
                        print("Error decoding product JSON: \(error)")
                    }
                }
            }
            
            // Call the completion handler with the array of all products
            completion(productsArray)
        }
    }


    
    
}
