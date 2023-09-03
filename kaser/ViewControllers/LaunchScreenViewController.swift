//
//  LaunchScreenViewController.swift
//  kaser
//
//  Created by iMad on 30/08/2023.
//

import UIKit

class LaunchScreenViewController: UIViewController, LogInViewProtocol {
    
    var presenter: LogInPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = LogInPresenter(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "isSaveSelected") == true){
            if let email = UserDefaults.standard.value(forKey: "email") as? String {
                if let password = UserDefaults.standard.value(forKey: "password") as? String {
                    self.presenter.checkTxtField(email: email, password: password)
                }
            }
        }
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        UIApplication.present(viewController: viewController)
        
    }
    
}
