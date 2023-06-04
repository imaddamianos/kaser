//
//  UIApplication.swift
//  kaser
//
//  Created by imps on 9/25/21.
//

import UIKit


extension UIApplication {
    
    
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    
    
    class func push(viewController: UIViewController)  {
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    class func popVC() {
        UIApplication.topViewController()?.view.endEditing(true)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    class func popToVC(viewController: UIViewController) {
        UIApplication.topViewController()?.view.endEditing(true)
        UIApplication.topViewController()?.navigationController?.popToViewController(viewController, animated: true)
    }
    
    class func present(viewController: UIViewController) {
        UIApplication.topViewController()?.view.endEditing(true)
        if let vc = UIApplication.topViewController()?.presentedViewController {
            vc.present(viewController, animated: true, completion: nil)
            return
        }
        
        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
    }

    
}
