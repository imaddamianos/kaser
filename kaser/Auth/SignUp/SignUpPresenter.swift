//
//  SignUpPresenter.swift
//  kaser
//
//  Created by imps on 9/24/21.
//

import Foundation
import Firebase
import SCLAlertView

protocol SignUpViewProtocol: AnyObject {
    
}

class SignUpPresenter{
    
    var navigationController = UINavigationController()
    
    weak var view: SignUpViewProtocol?
    init(view: SignUpViewProtocol) {
        self.view = view
    }
    
    func checkTxtField(email: String, password: String, confirmPass: String){
        naviToInfo()
        if password == confirmPass{
            firebaseRef.createUser(withEmail: email, password: password) { authResult, Error in
//                guard let StrongSelf = self else{
//                    return
//                }
                   guard let user = authResult?.user, Error == nil else {
                    if let errCode = AuthErrorCode(rawValue: Error!._code) {
                        
                        switch errCode {
                        case .emailAlreadyInUse:
                            newEmail = email
                            newPass = password
                            DispatchQueue.main.async {
                                SCLAlertView().showError("Email exist", subTitle: "\(email) is registered, go to forget password to reset your password")
                                let appearance = SCLAlertView.SCLAppearance(
                                       showCloseButton: false // if you dont want the close button use false
                                   )
                                let alertView = SCLAlertView(appearance: appearance)
                                alertView.addButton("OK") {
                                    print("button tapped")
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as UIViewController
                                    viewController.modalPresentationStyle = .fullScreen
                                    UIApplication.present(viewController: viewController)
                                }
                            }
                        case .weakPassword:
                            DispatchQueue.main.async {
                                SCLAlertView().showWarning("Weak Password", subTitle: "Make sure your password contain letters and numbers")
                            }
                        default:
                            print("Create User Error: \(String(describing: Error))")
                        }
                    }
                     return
                   }
                
                    self.naviToInfo()
                newEmail = email
                newPass = password
                    print("\(user.email!) created")
                 self.navigationController.popViewController(animated: true)
                 
               }
            
        }else{
            DispatchQueue.main.async {
                SCLAlertView().showWarning("Mismatch Password", subTitle: "Make sure your password is confirmed")
            }
        }
    
    }
    func naviToInfo(){
        firebaseRef.currentUser?.sendEmailVerification { error in }
        
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpInfoVC") as UIViewController
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.present(viewController: viewController)
        
    }
}
