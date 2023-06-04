//
//  ForgetPasswordPresenter.swift
//  kaser
//
//  Created by imps on 10/21/21.
//

import Foundation
import Firebase
import SCLAlertView

protocol ForgetPasswordProtocol: AnyObject {
    
}

class ForgetPasswordPresenter{
    
    weak var view: ForgetPasswordProtocol?
    init(view: ForgetPasswordProtocol) {
        self.view = view
    }
    func checkEmailToSend(email: String){
        
        firebaseRef.sendPasswordReset(withEmail: email, completion: { (Error) in
                    if Error == nil{
                            print("email sent")
                 let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false // if you dont want the close button use false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("OK") {
                        print("button tapped")
                     self.naviToHome()
                    }
                alertView.showSuccess("Email Sent", subTitle: "Please check your email inbox and click on the link to reset your password")
                        
                        
                    } else {
                        if let errCode = AuthErrorCode(rawValue: Error!._code) {
                            switch errCode {
                            case.missingEmail:
                                alertView.showError("No Email", subTitle: "Make sure your entered an Email address" )
                            case.invalidEmail:
                                    alertView.showError("Invalid Email", subTitle: "Make sure your entered an Email address" )
                            case.userNotFound:
                                alertView.showError("Invalid Email", subTitle: "Make sure your entered a valid Email address" )
                            default:
                                print("Sending email failed: \(String(describing: Error))")
                            }
                        }
                        print(Error?.localizedDescription as Any)
                    }
                })
    }
    
    func naviToHome(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") 
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.present(viewController: viewController)

        }
    }

}

