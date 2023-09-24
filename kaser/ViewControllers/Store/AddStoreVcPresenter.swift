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
    
    func addStore(storeName: String, phone: String, address: [String?:String?],LocationName: String, delivery: String, description: String, image: String){
//        let UserId = emailID.replace(target: ".", withString: "-")
//        newID = UserId
        APICalls.shared.addStoreInfo(storeName: storeName,phone: phone, address: address,LocationName: LocationName, delivery: delivery, description: description, image: image){[weak self] (isSuccess) in
        guard let StrongSelf = self else{
            return
        }
        if !isSuccess { return }
        
        StrongSelf.naviToHome()
           
    }
}
    
    func naviToHome(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.present(viewController: viewController)

        }
    }
    
}
