//
//  SignUpVC.swift
//  kaser
//
//  Created by imps on 9/23/21.
//

import UIKit
import SkyFloatingLabelTextField
import SCLAlertView


class SignUpVC: UIViewController, SignUpViewProtocol {
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtPass: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtConfirmPass: SkyFloatingLabelTextField!
    @IBOutlet var vwLogo: UIView!
    @IBOutlet var imgLogo: UIImageView!
    
    var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    func setupView(){
        
        #if DEBUG
        self.txtEmail.text = "imad-damianos@hotmail.com"
        self.txtPass.text = "imadimad"
        self.txtConfirmPass.text = "imadimad"
        #endif
        hideKeyboard()
        self.presenter = SignUpPresenter(view: self)
        vwLogo.cornerRadius(cornerRadius: vwLogo.layer.frame.height / 2)
        imgLogo.cornerRadius(cornerRadius: imgLogo.layer.frame.height / 2)
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if !txtEmail.text!.isEmpty || !txtPass.text!.isEmpty || !txtConfirmPass.text!.isEmpty{
            if txtEmail.text!.isEmpty {
                SCLAlertView().showInfo("Notice", subTitle: "Enter an E-mail address")
            }else if txtPass.text!.isEmpty{
                SCLAlertView().showInfo("Notice", subTitle: "Enter a valid Password")
            }else if txtConfirmPass.text!.isEmpty{
                SCLAlertView().showInfo("Notice", subTitle: "Please confirm your Password")
            }else{
                presenter.checkTxtField(email: txtEmail.text!, password: txtPass.text!, confirmPass: txtConfirmPass.text!)
            }
        }else{
            SCLAlertView().showNotice("Notice", subTitle: "Please fill in the information below")
        }
    }
}

