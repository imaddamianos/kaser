//
//  ForgetPasswordVC.swift
//  kaser
//
//  Created by UDU Jobs on 10/21/21.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import SCLAlertView

class ForgetPasswordVC: UIViewController, ForgetPasswordProtocol {

    var presenter: ForgetPasswordPresenter!
    @IBOutlet var emailText: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @IBAction func nextBtnTapped(_ sender: Any) {
        if let emailReset = emailText.text {
            
            presenter.checkEmailToSend(email: emailReset)
        }
    }
    func setupView(){
        self.presenter = ForgetPasswordPresenter(view: self)
    }
}
