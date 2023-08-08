//
//  SignUpInfoVcPresenter.swift
//  kaser
//
//  Created by imps on 10/16/21.
//

import Foundation

protocol SignUpInfoViewProtocol: AnyObject{
    
}

class SignUpInfoVcPresenter{
    
    weak var view: SignUpInfoViewProtocol?
    init(view: SignUpInfoViewProtocol) {
        self.view = view
    }
    
    func addSeller(userName: String,firstname: String, lastName: String, email: String, password: String, mobile: String, DOB: String, storeName: String, location: [String?:String?], userType:String, image: String){
        let emailID = email.replace(target: "@", withString: "-")
        let UserId = emailID.replace(target: ".", withString: "-")
        newID = UserId
        APICalls.shared.addSellerInfo(userName: userName,firstName: firstname, lastName: lastName, email: email, mobile: mobile, DateOfBirth: DOB, storeName: storeName, location: location, userType: userType, image: image, pass: password){[weak self] (isSuccess) in
        guard let StrongSelf = self else{
            return
        }
        if !isSuccess { return }
        
        StrongSelf.naviToHome()
           
    }
}
    func addBuyer(userName: String,firstname: String, lastName: String, email: String, password: String, mobile: String,location: [String?:String?], DOB: String, userType:String, image: String){
        let emailID = email.replace(target: "@", withString: "-")
        let UserId = emailID.replace(target: ".", withString: "-")
        newID = UserId
        APICalls.shared.addBuyerInfo(userName: userName,firstName: firstname, lastName: lastName, email: email, mobile: mobile, DateOfBirth: DOB, userType: userType, image: image, location: location, pass: password){[weak self] (isSuccess) in
        guard let StrongSelf = self else{
            return
        }
        if !isSuccess { return }
        
        StrongSelf.naviToHome()
           
    }
}
    func checkUserName(userName: String,type: String, completionBlock: @escaping (Bool) -> ()){
        ref.child(type).child(userName).getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            let value = snapshot.value as? NSDictionary
              let Usrname = value?["UserName"] as? String ?? ""
            if Usrname == userName{
                completionBlock(false)
            }else{
                completionBlock(true)
            }
        })
        
    }
    
    func naviToHome(){
        let newViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        newViewController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
    }
}

