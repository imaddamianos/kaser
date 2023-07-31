//
//  AddProductVcPresenter.swift
//  kaser
//
//  Created by iMad on 23/07/2023.
//

import Foundation

protocol AddProductViewProtocol: AnyObject {
    
}

class AddProductVcPresenter{
    
    weak var view: AddProductViewProtocol?
    init(view: AddProductViewProtocol) {
        self.view = view
    }
    
    func addProduct(productName: String, storeName: String, brand: String, car: String, condition: String, description: String, image: String, completion: (Bool) -> Void){
//        let UserId = emailID.replace(target: ".", withString: "-")
//        newID = UserId
        APICalls.shared.addProductInfo(productName: productName, storeName: storeName,brand: brand, car: car, condition: condition, description: description, image: image){[weak self] (isSuccess) in
        guard let StrongSelf = self else{
            return
        }
        if !isSuccess { return }
//        StrongSelf.naviToStore()self.dismiss(animated: true, completion: nil)
           
    }
        completion(true)
}
//    func naviToStore(){
//        DispatchQueue.main.async {
//            let viewController:UIViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyStoreViewController")
//            viewController.modalPresentationStyle = .fullScreen
//            UIApplication.findPrevious(self)
//
//        }
//    }

}
