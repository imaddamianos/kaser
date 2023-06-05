//
//  GFunction.swift
//  kaser
//
//  Created by imps on 9/24/21.
//

import Foundation
import SCLAlertView
//import ProgressHUD

class GFunction: NSObject {
    static let shared : GFunction = GFunction()
    
    func showAlert(_ title: String, message: String, btnName: String, btnAction: @escaping () -> Void){
        var action: () -> Void
        action = btnAction
        let appearance = SCLAlertView.SCLAppearance(
               showCloseButton: false // if you dont want the close button use false
           )
           let alertView = SCLAlertView(appearance: appearance)
           alertView.addButton(btnName) {
               print("Ok button tapped")
            action()

           }
       alertView.showSuccess(title, subTitle: message)
    }
    
    func addLoader(_ message : String? = nil) {
        
        performOn(.main) {
//            ProgressHUD.show(message ?? "Please Wait ...")
//            ProgressHUD.animationType = .lineScaling
//            ProgressHUD.colorHUD = .clear
//            ProgressHUD.colorBackground = .clear
//            ProgressHUD.colorAnimation = .colorOriginGreen
//            ProgressHUD.colorProgress = .colorYellow
//            ProgressHUD.colorStatus = .label
//            ProgressHUD.fontStatus = .boldSystemFont(ofSize: 24)
        }
    }
    
    func showSuccess(){
//        ProgressHUD.showSuccess("Success", image: .checkmark, interaction: true)
    }
    
    func removeLoader() {
        performOn(.main) {
//            ProgressHUD.dismiss()
        }
     }
    
}
