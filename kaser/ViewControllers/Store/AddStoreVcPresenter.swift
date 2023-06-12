//
//  AddStoreVcPresenter.swift
//  kaser
//
//  Created by iMad on 12/06/2023.
//

import Foundation

protocol AddStoreViewProtocol: AnyObject {
    
}

class AddStoreVcPresenter{
    
    weak var view: AddStoreViewProtocol?
    init(view: AddStoreViewProtocol) {
        self.view = view
    }
    
    func addStore(storeName: String, phone: String, address: String, delivery: String, description: String, image: String){
//        let emailID = email.replace(target: "@", withString: "-")
//        let UserId = emailID.replace(target: ".", withString: "-")
//        newID = UserId
//        APICalls.shared.addBuyerInfo(userName: userName,firstName: firstname, lastName: lastName, email: email, mobile: mobile, DateOfBirth: DOB, userType: userType, image: image, pass: password){[weak self] (isSuccess) in
//        guard let StrongSelf = self else{
//            return
//        }
//        if !isSuccess { return }
//        
//        StrongSelf.naviToHome()
//           
//    }
}
    
}
