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
//        let UserId = emailID.replace(target: ".", withString: "-")
//        newID = UserId
        APICalls.shared.addStoreInfo(storeName: storeName,phone: phone, address: address, delivery: delivery, description: description, image: image){[weak self] (isSuccess) in
        guard let StrongSelf = self else{
            return
        }
        if !isSuccess { return }
        
        StrongSelf.naviToStore()
           
    }
}
    
    func naviToStore(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyStoreViewController")
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.present(viewController: viewController)

        }
    }
    
}
