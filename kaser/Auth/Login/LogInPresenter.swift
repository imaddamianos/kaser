//
//  LogInPresenter.swift
//  kaser
//
//  Created by imps on 10/7/21.
//
import Foundation
import SCLAlertView
import Firebase

protocol LogInViewProtocol: AnyObject {
    
}

class LogInPresenter{
    
    weak var view: LogInViewProtocol?
    init(view: LogInViewProtocol) {
        self.view = view
    }
    
    func checkTxtField(email: String, password: String){
        GFunction.shared.addLoader("Logging In")
        newEmail = email
        newPass = password
        let emailID = email.replace(target: "@", withString: "-")
        let UserId = emailID.replace(target: ".", withString: "-")
        newID = UserId
        firebaseRef.signIn(withEmail: email, password: password, completion: { [weak self] Result, Error in
            
            guard let StrongSelf = self else{
                return
            }
//            
            guard Error == nil else {
                if let errCode = AuthErrorCode(rawValue: Error!._code) {

                    switch errCode {
                        case .userNotFound:
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Wrong Email", subTitle: "Make sure your email \(email) is registered")
                    }
                        case .wrongPassword:
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Wrong Password", subTitle: "Make sure your password is correct")
                    }
                    case .tooManyRequests:
                        DispatchQueue.main.async {
                        SCLAlertView().showInfo("Forget Password", subTitle: "Too many request please reset password")
                    }
                        default:
                            print("Create User Error: \(String(describing: Error))")
                    }
                }
                GFunction.shared.removeLoader()
                return
            }
            
            print("you have siged in")
            GFunction.shared.removeLoader()
            StrongSelf.naviToHome()
        })
       
    }
    func naviToHome(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.present(viewController: viewController)
        }
    }
    
}
