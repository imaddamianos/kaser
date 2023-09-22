//
//  GFunction.swift
//  kaser
//
//  Created by imps on 9/24/21.
//

import Foundation
import SCLAlertView
import ProgressHUD
import SDWebImage

class GFunction: NSObject {
    static let shared : GFunction = GFunction()
    
    func loadImageAsync(from url: URL?, into imageView: UIImageView, completion: (() -> Void)? = nil) {
            imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error)")
                } else {
                    imageView.image = image
                }
                completion?()
            }
        }

    
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
    
    func showAlertWithCancel(_ title: String, message: String, okBtnName: String, cancelBtnName: String, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        // Add the "OK" button
        alertView.addButton(okBtnName) {
            print("OK button tapped")
            okAction()
        }
        
        // Add the "Cancel" button
        alertView.addButton(cancelBtnName) {
            print("Cancel button tapped")
            cancelAction()
        }
        
        alertView.showSuccess(title, subTitle: message)
    }
    
    func addLoader(_ message : String? = nil) {
        
        performOn(.main) {
            ProgressHUD.show(message ?? "Please Wait ...")
            ProgressHUD.animationType = .lineScaling
            ProgressHUD.colorHUD = .clear
            ProgressHUD.colorBackground = .clear
            ProgressHUD.colorAnimation = .originalColor
            ProgressHUD.colorProgress = .colorYellow
            ProgressHUD.colorStatus = .label
            ProgressHUD.fontStatus = .boldSystemFont(ofSize: 24)
        }
    }
    
    func showSuccess(){
        ProgressHUD.showSuccess("Success", image: .checkmark, interaction: true)
    }
    
    func removeLoader() {
        performOn(.main) {
            ProgressHUD.dismiss()
        }
     }
    
    func addBlurBackground(toView view: UIView) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    func sideMenuItems(userType:String) -> [SideMenuModel]{
        if userType == "Seller" {
            return [
                SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
                SideMenuModel(icon: UIImage(systemName: "person.crop.circle.fill")!, title: "Profile"),
                SideMenuModel(icon: UIImage(systemName: "text.bubble.fill")!, title: "Chat"),
                SideMenuModel(icon: UIImage(systemName: "star.fill")!, title: "Favorite"),
                SideMenuModel(icon: UIImage(systemName: "list.bullet.rectangle")!, title: "Reviews"),
                SideMenuModel(icon: UIImage(systemName: "gearshape.fill")!, title: "Settings"),
                SideMenuModel(icon: UIImage(systemName: "building.2.fill")!, title: "My Store")
            ]
        } else {
            return [
                SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
                SideMenuModel(icon: UIImage(systemName: "person.crop.circle.fill")!, title: "Profile"),
                SideMenuModel(icon: UIImage(systemName: "text.bubble.fill")!, title: "Chat"),
                SideMenuModel(icon: UIImage(systemName: "star.fill")!, title: "Favorite"),
                SideMenuModel(icon: UIImage(systemName: "list.bullet.rectangle")!, title: "Reviews"),
                SideMenuModel(icon: UIImage(systemName: "gearshape.fill")!, title: "Settings")
            ]
        }
    }
    
}
